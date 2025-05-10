import SwiftUI

/// Gives the main tab navigation for the app and uses a user's information
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
