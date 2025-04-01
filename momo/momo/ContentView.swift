import SwiftUI
import Firebase

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var isUserLoggedIn = true  // Set this to true to bypass login

    var body: some View {
        // Main Tab Navigation regardless of login status
        TabView(selection: $selectedTab) {
            HomeScreen()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            FriendsListScreen()
                .tabItem {
                    Label("Friends", systemImage: "person.2.fill")
                }
                .tag(1)

            PersonalPage()
                .tabItem {
                    Label("My Page", systemImage: "person.crop.circle")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}

