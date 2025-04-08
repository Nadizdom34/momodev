import SwiftUI
<<<<<<< Updated upstream
import Firebase

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var isUserLoggedIn = true  // Set this to true to bypass login
=======
import RiveRuntime

struct ContentView: View {
    @State private var showLoginScreen = false
    @State private var showFriendsScreen = false
    @State private var showPersonalPage = false
>>>>>>> Stashed changes

    // Load the Rive animation
    let riveViewModel = RiveViewModel(fileName: "character_test")

    var body: some View {
<<<<<<< Updated upstream
        // Main Tab Navigation regardless of login status
        TabView(selection: $selectedTab) {
            HomeScreen()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
=======
        VStack {
            Spacer()
            
            Text("MOMO DEV")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
            
            // Replace the pink circle with the Rive animation
            riveViewModel.view()
                .frame(width: 300, height: 300) // Adjust as needed
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
>>>>>>> Stashed changes
                }
                .tag(0)

            FriendsListScreen()
                .tabItem {
                    Label("Friends", systemImage: "person.2.fill")
                }
<<<<<<< Updated upstream
                .tag(1)

            PersonalPage()
                .tabItem {
                    Label("My Page", systemImage: "person.crop.circle")
                }
                .tag(2)
=======
                
                Button(action: {
                    showFriendsScreen = true
                }) {
                    Text("Friends List")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $showFriendsScreen) {
                    FriendsListScreen()
                }
                
                Button(action: {
                    showPersonalPage = true
                }) {
                    Text("My Page")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $showPersonalPage) {
                    PersonalPage()
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
>>>>>>> Stashed changes
        }
    }
}

#Preview {
    ContentView()
}


