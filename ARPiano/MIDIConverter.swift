import Foundation

struct MidiFileMid: Codable {
    let notes: [Note]
}

struct Note: Codable {
    let duration: Double
    let durationTicks: Double
    let midi: UInt8
    let name: String
    let ticks: Double
    let time: Double
    let velocity: Double
}

class MIDIConverter {
    func convertMIDIToJSON(fileName: String) -> String? {
        // Get the path of the MIDI file
        guard let path = Bundle.main.path(forResource: fileName, ofType: "mid") else {
            print("MIDI file not found.")
            return nil
        }
        
        // Read the MIDI file data
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("Failed to read MIDI file data.")
            return nil
        }
        
        // MIDI file format: MThd + <header chunk length> + <header data> + MTrk + <track chunk length> + <track data> + ...
        
        // Check if it's a valid MIDI file
        guard data.count >= 14,  // Minimum size for a valid MIDI file
              data.prefix(4) == "MThd".data(using: .ascii) else {
            print("Invalid MIDI file format.")
            return nil
        }
        
        // Get the number of tracks from the header chunk
        let numTracks = UInt16(bigEndian: data.subdata(in: 10..<12).withUnsafeBytes { $0.pointee })
        
        var notes: [Note] = []
        
        // Iterate through each track chunk
        var index = 14  // Start after the header chunk
        for _ in 0..<numTracks {
            // Check if it's a valid track chunk
            guard data.count >= index + 8,
                  data[index..<index+4] == "MTrk".data(using: .ascii) else {
                print("Invalid track chunk format.")
                return nil
            }
            
            // Get the track chunk length
            let trackLength = Int(UInt32(bigEndian: data.subdata(in: index+4..<index+8).withUnsafeBytes { $0.pointee }))
            
            // Process the track events
            let trackData = data.subdata(in: index+8..<index+8+trackLength)
            processTrackData(trackData, notes: &notes)
            
            // Move to the next track chunk
            index += 8 + trackLength
        }
        
        let jsonData: [String: Any] = ["notes": notes]
        
        // Convert JSON data to a string
        guard let jsonDataString = try? JSONSerialization.data(withJSONObject: jsonData, options: []),
              let jsonString = String(data: jsonDataString, encoding: .utf8) else {
            print("Failed to convert JSON data to string.")
            return nil
        }
        
        // Return the JSON string
        return jsonString
        
        
        
    }
    
   
    private func processTrackData(_ data: Data, notes: inout [Note]) {
        // MIDI event format: <delta-time> + <event data>
        // Delta time: Variable-length quantity
        // Event data: <status byte> + <data bytes>
        // Note On event status byte: 0x9n (n: channel)
        // Data bytes: <note number>
    }
    
    
}

