import SwiftUI
import FirebaseCore
import FirebaseFirestore


struct ContentView: View {
    @State private var showLoginScreen = false
    @State private var showFriendsScreen = false  // New state for Friends List
    @State private var showPersonalPage = false

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
                    LoginScreen()
                }
                
                Button(action: {
                    showFriendsScreen = true  // Open Friends List
                }) {
                    Text("Friends List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $showFriendsScreen) {
                    FriendsListScreen()  // Displays the Friends List
                }
                
                Button(action: {
                    showPersonalPage = true  // Open PersonalPage List
                }) {
                    Text("My Page")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $showPersonalPage) {
                    PersonalPage()  // Displays the Friends List
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

