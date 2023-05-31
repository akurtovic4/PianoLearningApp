
import SwiftUI
import RealityKit
import Vision
import ARKit

struct ContentView : View {
    @State private var arView = ARView(frame: .zero)
    @State private var hpb: [Keys] = []
    @State private var isPlaying = false
   
    var body: some View {
        ARViewContainer(arView: $arView)
            .edgesIgnoringSafeArea(.all)
        
        .padding().onAppear(perform: readFile)
        if !isPlaying {
                      Button(action: {
                          isPlaying = true
                         //nesto nesto
                          
                      }) {
                          Image(systemName: "play.circle.fill")
                              .resizable()
                              .frame(width: 80, height: 80)
                              .foregroundColor(.purple)
                      }
                      .padding()
                      .transition(.opacity)
                  }
              
    }
    
    
    private func readFile() {
      if let url = Bundle.main.url(forResource: "hpb", withExtension: "json"),
         let data = try? Data(contentsOf: url) {
        let decoder = JSONDecoder()
        if let jsonData = try? decoder.decode(JSONData.self, from: data) {
     //    self.hpb = jsonData.notes
            print(jsonData.notes)
        }
      }
    }
}

struct JSONData: Decodable {
  let notes: [Keys]
}

struct Keys: Codable {
    
  let duration: Double
  let durationTicks: Double
  let name: String
  let ticks: Double
  let time: Double
  let velocity: Double

}


extension Entity {

    func getModelEntity() -> ModelEntity? {

        findModelEntity(in: self.children[0])
        

    }

    

    private func findModelEntity(in entity: Entity) -> ModelEntity? {

        guard let entity = entity as? ModelEntity else {

           return findModelEntity(in: entity.children[0])

        }

        

        return entity

    }

}




struct ARViewContainer: UIViewRepresentable {
    @Binding var arView: ARView
    
    func makeUIView(context: Context) -> ARView {
        arView.session.delegate = context.coordinator
        arView.debugOptions = [
            //.showPhysics,
            //.showAnchorOrigins,
            //.showAnchorGeometry
        ]
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        
        //Person Occultation
        config.frameSemantics = .personSegmentationWithDepth
        
        arView.session.run(config)
        
        // Load the "Piano" scene from the "Experience" Reality File
        let pianoAnchor = try! Keyboard.loadPiano()
    
        
        // Attach the finger entity as a child of piano
        // pianoAnchor.addChild(fingerEntity)
        
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(pianoAnchor)
        
        pianoAnchor.generateCollisionShapes(recursive: true)
        let piano = pianoAnchor.keyboards as? Entity & HasCollision
        arView.installGestures(for: piano!)
        changingColors()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update the finger positions in the 3D model
        // ...
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(arView: $arView)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        @Binding var arView: ARView
        var shouldDetectFingers = true
        init(arView: Binding<ARView>) {
            _arView = arView
        }
        
        func detectFingers(in frame: ARFrame) -> [VNRecognizedPoint] {
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage)
            let request = VNDetectHumanHandPoseRequest()
            request.maximumHandCount = 2
            
            try? requestHandler.perform([request])
            
            guard let observations = request.results else {
                print("No hande detected")
                return []
            }
            
            return observations.compactMap {
                // make for all fingers, maybe user group
                try? $0.recognizedPoint(VNHumanHandPoseObservation.JointName.indexTip)
            }
        }
        
    }
    
    
/*
prva
    func changingColors(){

         guard let keyEntity = arView.scene.findEntity(named: "G1") else {
              print("Failed to find the mesh entity.")
              return

         }

         guard let modelEntity = keyEntity.getModelEntity() else {
             print("Faild to find ModelEntity")
             return

         }
         var material = SimpleMaterial()
         material.color = .init(tint: .purple)
         modelEntity.model?.materials[0] = material

     }

    
    private func getJSONData() -> JSONData? {
           guard let url = Bundle.main.url(forResource: "hpb", withExtension: "json"),
                 let data = try? Data(contentsOf: url) else {
               print("Failed to load JSON data.")
               return nil
           }
           
           let decoder = JSONDecoder()
           if let jsonData = try? decoder.decode(JSONData.self, from: data) {
               return jsonData
           } else {
               print("Failed to parse JSON data.")
               return nil
           }
       }
    
 
  
  
   

    func changingColors() {
        guard let jsonData = getJSONData() else {
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
                   
                    func changeTo(_ element: Int, _ color: UIColor) {
                        modelEntity.model?.materials[0] = UnlitMaterial(color: color)
                       }
                    changeTo(currentIndex, .white)//mesh c
                  //  nextMaterial.baseColor = .color(.white)
                    modelEntity.model?.materials[0] = nextMaterial
                    currentIndex += 1
                }
                
                
            }
        }
    }

  
  */
    
    private func getJSONData() -> JSONData? {
           guard let url = Bundle.main.url(forResource: "hpb", withExtension: "json"),
                 let data = try? Data(contentsOf: url) else {
               print("Failed to load JSON data.")
               return nil
           }
           
           let decoder = JSONDecoder()
           if let jsonData = try? decoder.decode(JSONData.self, from: data) {
               return jsonData
           } else {
               print("Failed to parse JSON data.")
               return nil
           }
       }
    
 
    func changingColors() {
        guard let jsonData = getJSONData() else {
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


    
    
    
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
