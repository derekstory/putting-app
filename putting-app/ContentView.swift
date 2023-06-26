import SwiftUI

struct ContentView: View {
    @State private var showButton = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(hex: "#4a828c"))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text("Putterz")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(y: showButton ? 0 : -UIScreen.main.bounds.height)
                        .animation(
                            .interpolatingSpring(mass: 1.0, stiffness: 100, damping: 10, initialVelocity: 0),
                            value: showButton
                        )
                        .onAppear {
                            withAnimation {
                                showButton = true
                            }
                        }
                    
                    Spacer()
                    
                    if showButton {
                        NavigationLink(destination: CameraTestView()) {
                            Text("Start")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.7)
                                .padding()
                                .background(Color(UIColor(hex: "#4a828c")))
                                .cornerRadius(10)
                        }
                        .offset(y: showButton ? 0 : UIScreen.main.bounds.height)
                        .animation(
                            .interpolatingSpring(mass: 1.0, stiffness: 100, damping: 10, initialVelocity: 0),
                            value: showButton
                        )
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
