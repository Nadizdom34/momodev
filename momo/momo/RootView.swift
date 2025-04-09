import SwiftUI
import FirebaseFirestore

struct RootView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("userId") private var userId: String?

    @State private var userData: [String: Any]?

    var body: some View {
        if isLoggedIn {
            if let userData = userData {
                MainTabView(userData: userData)
            } else {
                // Fetch userData from Firestore
                LoadingView()
                    .onAppear(perform: fetchUserData)
            }
        } else {
            QuickLoginView { data in
                self.userData = data
                self.isLoggedIn = true
            }
        }
    }

    private func fetchUserData() {
        guard let unwrappedUserId = userId else {
            // Fallback to login if userId is missing
            self.isLoggedIn = false
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(unwrappedUserId).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.userData = data.merging(["id": unwrappedUserId]) { $1 }
            } else {
                // If something went wrong, fallback to login
                self.isLoggedIn = false
            }
        }
    }
}

