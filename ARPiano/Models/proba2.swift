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
    
 
    
    func startTimer(arView:  ARView) {
        let midiNotes = MIDIConverter().loadMidi(fileName: "easymid")
        let prva = midiNotes?.first?.duration.inSeconds;
        
        let note = midiNotes?.first?.note;

       /* guard let jsonData = MidiFile.getJSONData() else {
            print("Failed to load JSON data.")
            return
        }*/
        
        var currentIndex = 0
        
        
        var numOfNotes = 0
        if let notes = midiNotes {
            numOfNotes = notes.endIndex
        } else {
            print("Failed to load MIDI notes.")
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            guard currentIndex < numOfNotes else {
                timer.invalidate()
                print("All key color changes completed.")
                return
            }
            
          //  let note = jsonData.notes[currentIndex]
            
           
       
            
            guard let note = note else {
                print("Invalid note value.")
                currentIndex += 1
                return
            }

            let noteName = String(note)
            print("Aminaaa")
            print (noteName)
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() ) {
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
