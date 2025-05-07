import SwiftUI
import FirebaseFirestore
import RiveRuntime

//Checks whether the user is logged in. If the user is logged in, shows the main tab view of Home, Friends, MyPage.
//Shows QuickLoginView otherwise.
struct ContentView: View {
    @Binding var userData: [String: Any]

    //Shows appropriate UI based on whether user is logged in or not
    var body: some View {
        Group {
            MainTabView(userData: userData)
        }
    }
    //Displays the main navigation tabs of Home, Friends, MyPage
    struct MainTabView: View {
        var userData: [String: Any]

        var body: some View {
            TabView {
                PersonalPage(userData: userData)
                    .tabItem { Label("My Page", systemImage: "person.crop.circle") }
                
                FriendsListScreen()
                    .tabItem { Label("Friends", systemImage: "person.2.fill") }
            }
        }
    }
}

