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
        
        let midiFileMid = MidiFileMid(notes: notes)
        
        // Convert the MIDI file structure to JSON data
        guard let jsonData = try? JSONEncoder().encode(midiFileMid) else {
            print("Failed to encode MIDI data to JSON.")
            return nil
        }
        
        // Save JSON data to a file
        let jsonFileName = "output.json"
        let jsonFilePath = getDocumentsDirectory().appendingPathComponent(jsonFileName)
        
        do {
            try jsonData.write(to: jsonFilePath)
            print("JSON file saved successfully: \(jsonFilePath)")
        } catch {
            print("Failed to save JSON file: \(error)")
            return nil
        }
        
        // Return the path of the JSON file
        return jsonFilePath.absoluteString
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    private func processTrackData(_ data: Data, notes: inout [Note]) {
        var deltaTime: UInt64 = 0
        var currentIndex = 0
        
        let dataBytes = [UInt8](data)
        var index = 0
        
        while index < dataBytes.count {
            let (eventDeltaTime, eventLength) = parseVariableLengthQuantity(dataBytes, startIndex: index)
            index += eventLength
            
            deltaTime += eventDeltaTime
            
            guard index < dataBytes.count else {
                break
            }
            
            let statusByte = dataBytes[index]
            index += 1
            
            let eventType = statusByte >> 4
            
            switch eventType {
            case 0x8: // Note Off
                let channel = statusByte & 0x0F
                let noteNumber = dataBytes[index]
                index += 1
                let velocity = dataBytes[index]
                index += 1
                
                // Create a new Note instance and append it to the notes array
                let note = Note(duration: 0, durationTicks: 0, midi: noteNumber, name: "", ticks: 0, time: 0, velocity: Double(velocity))
                notes.append(note)
                
            case 0x9: // Note On
                let channel = statusByte & 0x0F
                let noteNumber = dataBytes[index]
                index += 1
                let velocity = dataBytes[index]
                index += 1
                
                // Create a new Note instance and append it to the notes array
                let note = Note(duration: 0, durationTicks: 0, midi: noteNumber, name: "", ticks: 0, time: 0, velocity: Double(velocity))
                notes.append(note)
                
            default:
                break
            }
            
            currentIndex += 1
        }
    
    }

    private func parseVariableLengthQuantity(_ data: [UInt8], startIndex: Int) -> (UInt64, Int) {
        var value: UInt64 = 0
        var length = 0
        var index = startIndex
        
        repeat {
            let byte = data[index]
            index += 1
            let valueBits = byte & 0x7F
            value = (value << 7) | UInt64(valueBits)
            length += 1
        } while index < data.count && data[index - 1] & 0x80 != 0
        
        return (value, length)
    }



       private func decodeVariableLengthQuantity(_ bytes: [UInt8]) -> UInt64 {
           var value: UInt64 = 0

           for byte in bytes {
               value = (value << 7) | UInt64(byte & 0x7F)
           }

           return value
       }
    
    
}

