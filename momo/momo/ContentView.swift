import SwiftUI
import FirebaseFirestore
import RiveRuntime

/// Checks whether the user is logged in. If the user is logged in, shows the main tab view of Home, Friends, MyPage. Or it shows QuickLoginView otherwise.
struct ContentView: View {
    @Binding var userData: [String: Any]
    var body: some View {
        Group {
            MainTabView(userData: userData)
        }
    }
    struct MainTabView: View {
        var userData: [String: Any]

        var body: some View {
            TabView {
                PersonalPage(userData: userData)
                    .tabItem { Label("My Page", systemImage: "person.crop.circle") }
                
                FriendsListScreen(userId: userData["id"] as? String)
                    .tabItem { Label("Friends", systemImage: "person.2.fill") }
            }
        }
    }
}

