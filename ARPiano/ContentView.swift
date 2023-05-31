
import SwiftUI
import RealityKit
import Vision
import ARKit


struct ContentView : View {
    @State private var arView = ARView(frame: .zero)
    @StateObject private var viewModel = PianoViewModel()
    @State private var hpb: [Keys] = []
    @State private var isPlaying = false
    
    var body: some View {
        ARViewContainer(arView: $arView)
            .edgesIgnoringSafeArea(.all)
        
            .onAppear{
                viewModel.changingColors(arView: arView)
            }
        if !isPlaying {
                      Button(action: {
                          isPlaying = true
                      
                          
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
        init(arView: Binding<ARView>) {
            _arView = arView
        }
        
      
            
        
        }
        
    
    
    
/*
   
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
    
   
 


    
    
    
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
