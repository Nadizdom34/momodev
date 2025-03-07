import SwiftUI

struct ContentView: View {
    @State private var showLoginScreen = false

    var body: some View {
        VStack {
            Spacer()
            
            Text("MOMO DEV")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
            
            Circle()
                .fill(Color.pink.opacity(0.3))
                .frame(width: 300, height: 300)
                .padding()
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(action: {
                    showLoginScreen = true
                }) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $showLoginScreen) {
                    LoginScreen()  // Now references the separate file
                }
                
                Button(action: {
                    // Handle sign-up action
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}

