//
//  PianoViewModel.swift
//  ARPiano
//
//  Created by Amina Kurtović on 31. 5. 2023..
//

 import Foundation
 import RealityKit
 import UIKit
 
 class PianoViewModel : ObservableObject{
 
 @Published var isModalPresented = true
 
     func startTimer(arView: ARView) {
         guard let jsonData = MidiFile.getJSONData() else {
             print("Failed to load JSON data.")
             return
         }

         guard let firstNote = jsonData.notes.first else {
             print("No notes found in the JSON data.")
             return
         }

         guard let keyEntity = arView.scene.findEntity(named: firstNote.name) else {
             print("Failed to find the key entity for note: \(firstNote).")
             return
         }

         guard let modelEntity = keyEntity.getModelEntity() else {
             print("Failed to find ModelEntity for note: \(firstNote).")
             return
         }

         var material = SimpleMaterial()
         let blueColor = UIColor.blue
         material.baseColor = .color(.lightGray)
         modelEntity.model?.materials[0] = material

         DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
             material.baseColor = .color(.white)

             var currentIndex = 0

             Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                 guard currentIndex < jsonData.notes.count else {
                     timer.invalidate()
                     print("All key color changes completed.")
                     return
                 }

                 let note = jsonData.notes[currentIndex]

                 guard let keyEntity = arView.scene.findEntity(named: note.name) else {
                     print("Failed to find the key entity for note: \(note.name).")
                     currentIndex += 1
                     return
                 }

                 guard let modelEntity = keyEntity.getModelEntity() else {
                     print("Failed to find ModelEntity for note: \(note.name).")
                     currentIndex += 1
                     return
                 }

                 var material = SimpleMaterial()
                 let color = UIColor.purple // Set the desired color for the key
                 material.baseColor = .color(color)
                 modelEntity.model?.materials[0] = material

                 DispatchQueue.main.asyncAfter(deadline: .now() + note.duration) {
                     var nextMaterial = SimpleMaterial()
                     let color = UIColor.clear // Set the desired color for the key
                     nextMaterial.baseColor = .color(.white)
                     modelEntity.model?.materials[0] = nextMaterial

                     currentIndex += 1
                 }
             }
         }
     }

 
 
 
 func createMaterialColor(for noteName: String) -> UIColor {
 // Map MIDI note names to colors
 switch noteName {
 case "C1":
 return .red
 case "D1":
 return .green
 case "E1":
 return .blue
 // Add more cases for other keys...
 default:
 return .purple
 }
 }
 
 func dismissModal() {
 isModalPresented = false
 }
 
 }
 
 
 /*
  prava
  func changingColors(arView: ARView) {
  guard let jsonData = MidiFile.getJSONData() else {
  print("Failed to load JSON data.")
  return
  }
  
  DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
  var currentIndex = 0
  
  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
  guard currentIndex < jsonData.notes.count else {
  timer.invalidate()
  print("All key color changes completed.")
  return
  }
  
  let note = jsonData.notes[currentIndex]
  
  guard let keyEntity = arView.scene.findEntity(named: note.name) else {
  print("Failed to find the key entity for note: \(note.name).")
  currentIndex += 1
  return
  }
  
  guard let modelEntity = keyEntity.getModelEntity() else {
  print("Failed to find ModelEntity for note: \(note.name).")
  currentIndex += 1
  return
  }
  
  var material = SimpleMaterial()
  let color = UIColor.purple // Set the desired color for the key
  material.baseColor = .color(color)
  modelEntity.model?.materials[0] = material
  
  DispatchQueue.main.asyncAfter(deadline: .now() + note.duration) {
  var nextMaterial = SimpleMaterial()
  let color = UIColor.clear // Set the desired color for the key
  nextMaterial.baseColor = .color(color)
  modelEntity.model?.materials[0] = nextMaterial
  
  //                    func changeTo(_ element: Int, _ color: UIColor) {
  //                        modelEntity.model?.materials[0] = UnlitMaterial(color: color)
  //                       }
  //                    changeTo(currentIndex, .clear)//mesh c
  //                  //  nextMaterial.baseColor = .color(.white)
  //                    modelEntity.model?.materials[0] = nextMaterial
  
  currentIndex += 1
  }
  
  
  }
  }
  }
  
  
 */


