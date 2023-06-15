//
//  proba3.swift
//  ARPiano
//
//  Created by Amina Kurtović on 15. 6. 2023..
//

//
//  PianoViewModel.swift
//  ARPiano
//
//  Created by Amina Kurtović on 31. 5. 2023..
//
/*
import Foundation
import RealityKit
import UIKit

class PianoViewModel : ObservableObject{

    @Published var isModalPresented = true
    
 
    
    func startTimer(arView: ARView) {
        let midiNotes = MIDIConverter().loadMidi(fileName: "easymid")
        var currentIndex = 0

        var numOfNotes = 0
        if let notes = midiNotes {
            numOfNotes = notes.endIndex
        } else {
            print("Failed to load MIDI notes.")
            return
        }

 let durationInSeconds = midiNotes?[currentIndex].duration.inSeconds ?? 0.0
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            guard currentIndex < numOfNotes else {
                timer.invalidate()
                print("All key color changes completed.")
                return
            }

            guard let note = midiNotes?[currentIndex].note else {
                print("Invalid note value.")
                currentIndex += 1
                return
            }

            let noteName = String(note)
            print("Aminaaa")
            print(noteName)
            guard let keyEntity = arView.scene.findEntity(named: noteName) else {
                print("Failed to find the key entity for note: \(noteName).")
                currentIndex += 1
                return
            }

            guard let modelEntity = keyEntity.getModelEntity() else {
                print("Failed to find ModelEntity for note: \(noteName).")
                currentIndex += 1
                return
            }

            var material = SimpleMaterial()
            let color = UIColor.purple
            material.baseColor = .color(color)
            modelEntity.model?.materials[0] = material

            let durationInSeconds = midiNotes?[currentIndex].duration.inSeconds ?? 0.0
            DispatchQueue.main.asyncAfter(deadline: .now() + durationInSeconds) {
                var nextMaterial = SimpleMaterial()
                let color = UIColor.clear // Set the desired color for the key
                nextMaterial.baseColor = .color(.white)
                modelEntity.model?.materials[0] = nextMaterial

                currentIndex += 1
            }
        }
    }

    
    func dismissModal() {
           isModalPresented = false
       }
    
}


*/


  

