import SwiftUI
import FirebaseFirestore

struct RootView: View {
    @State private var isLoggedIn = false
    @State private var userData: [String: Any]?

    var body: some View {
        if isLoggedIn, let userData = userData {
            MainTabView(userData: userData)
        } else {
            QuickLoginView { data in
                self.userData = data
                self.isLoggedIn = true
            }
        }
    }
}

