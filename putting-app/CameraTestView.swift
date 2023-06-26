import SwiftUI
import AVFoundation

struct CameraTestView: View {
    @State private var isCameraAuthorized = false
    @State private var isCameraStarted = false
    @State private var cameraPosition: AVCaptureDevice.Position = .back
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Camera Test")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                if isCameraAuthorized {
                    CameraPreview(cameraPosition: cameraPosition)
                        .frame(width: 200, height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onAppear {
                            isCameraStarted = true
                        }
                } else {
                    Text("Camera access not granted")
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    toggleCameraPosition()
                }) {
                    Text("Toggle Camera")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
        }
        .onAppear {
            checkCameraAuthorization()
        }
    }
    
    private func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isCameraAuthorized = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                isCameraAuthorized = granted
            }
        default:
            isCameraAuthorized = false
        }
    }
    
    private func toggleCameraPosition() {
        cameraPosition = (cameraPosition == .back) ? .front : .back
    }
}

struct CameraTestView_Previews: PreviewProvider {
    static var previews: some View {
        CameraTestView()
    }
}

struct CameraPreview: UIViewRepresentable {
    let cameraPosition: AVCaptureDevice.Position
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.global(qos: .userInitiated).async {
            let captureSession = AVCaptureSession()
            
            let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: cameraPosition).devices
            
            guard let device = devices.first,
                  let input = try? AVCaptureDeviceInput(device: device)
            else {
                return
            }
            
            captureSession.addInput(input)
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            DispatchQueue.main.async {
                previewLayer.frame = uiView.bounds
            }
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.connection?.videoOrientation = .portrait
            
            DispatchQueue.main.async {
                uiView.layer.sublayers?.removeAll()
                uiView.layer.addSublayer(previewLayer)
            }
            
            captureSession.startRunning()
        }
    }
}
