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
        guard let unwrappedUserId = userId, !unwrappedUserId.isEmpty else {
            print("❌ Missing or empty userId – logging out.")
            self.isLoggedIn = false
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(unwrappedUserId).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.userData = data.merging(["id": unwrappedUserId]) { $1 }
            } else {
                print("Failed to fetch user data: \(error?.localizedDescription ?? "unknown error")")
                self.isLoggedIn = false
            }
        }
    }
}

