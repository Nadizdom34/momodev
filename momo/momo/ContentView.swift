import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var userData: [String: Any]?
    @AppStorage("userId") private var userId: String?


    var body: some View {
        Group {
            if isLoggedIn, let userData = userData {
                MainTabView(userData: userData) // ✅ Use new MainTabView
            } else {
                QuickLoginView { data in
                    self.userData = data
                    self.isLoggedIn = true
                }
            }
        }
    }

    struct MainTabView: View {
        var userData: [String: Any]

        var body: some View {
            TabView {
                HomeScreen()
                    .tabItem { Label("Home", systemImage: "house.fill") }
                
                FriendsListScreen()
                    .tabItem { Label("Friends", systemImage: "person.2.fill") }

                PersonalPage(userData: userData) // ✅ Pass userData here
                    .tabItem { Label("My Page", systemImage: "person.crop.circle") }
            }
        }
    }
}

