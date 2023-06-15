
import SwiftUI
import RealityKit
import Vision
import ARKit


struct ContentView : View {
    @State private var arView = ARView(frame: .zero)
    @StateObject private var viewModel = PianoViewModel()
    @State private var hpb: [Keys] = []
    @State private var isPlaying = false
    @State private var isModalPresented = true
    
    
    
    var body: some View {
            ZStack {
                ARViewContainer(arView: $arView)
                    .edgesIgnoringSafeArea(.all)
                
                if isModalPresented {
                    ModalView(dismissAction: {
                        isModalPresented = false
                    })
                }
                
                if !isModalPresented && !isPlaying {
                    Button(action: {
                        isPlaying = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                            viewModel.startTimer(arView: arView)
                        }
                    }) {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .transition(.opacity)
                    .opacity(isModalPresented ? 0 : 1) // Show the play button only if the modal is not presented
                    .animation(.easeIn(duration: 0.5)) // Add animation for smooth visibility transition
                }
            }
            .onAppear {
                let converter = MIDIConverter()
                if let jsonString = converter.loadMidi(fileName: "easymid") {
                    print(jsonString)
                } else {
                    print("Failed to convert MIDI to JSON.")
                }
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
        let pianoAnchor = try! Experience.loadPiano()
    
        
      
        
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(pianoAnchor)
        
        pianoAnchor.generateCollisionShapes(recursive: true)
        let piano = pianoAnchor.keyboards as? Entity & HasCollision
        arView.installGestures(for: piano!)

        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
       
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
        

    
    
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
