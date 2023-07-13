//
//  ModalView.swift
//  ARPiano
//
//  Created by Amina Kurtović on 12. 6. 2023..
//

import Foundation
import SwiftUI

struct ModalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isStartPressed = false
    var dismissAction: () -> Void
    
    
    
    
    var body: some View {
        ZStack {
            Color.white
                .opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("PianoLearningApp")
                    .font(.title)
                    .padding()
                    .foregroundColor(Color.black)
                
                Text("After you press the -Start playing- button, adjust virtual keyboard to your RL keyboard and press play. After 10 sec, proper keys will turn purple.")
                    .font(.footnote)
                    .italic()
                    .padding(30)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
                Button(action: dismissAction) {
                    Text("Start playing")
                        .font(.headline)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
    
}
   
