//
//  MidiFile.swift
//  ARPiano
//
//  Created by Amina Kurtović on 31. 5. 2023..
//

import Foundation

struct MidiFile: Decodable {
  let notes: [Keys]
    
    
    static func getJSONData() -> MidiFile? {
              guard let url = Bundle.main.url(forResource: "hpb", withExtension: "json"),
                    let data = try? Data(contentsOf: url) else {
                  print("Failed to load JSON data.")
                  return nil
              }
              
              let decoder = JSONDecoder()
              if let jsonData = try? decoder.decode(MidiFile.self, from: data) {
                  return jsonData
              } else {
                  print("Failed to parse JSON data.")
                  return nil
              }
          }
}

struct Keys: Codable {
    
  let duration: Double
  let durationTicks: Double
  let name: String
  let ticks: Double
  let time: Double
  let velocity: Double

}

