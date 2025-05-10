import SwiftUI
import FirebaseFirestore
import FirebaseAuth

/// The root navigation logic for the app, handles whether to show the main app, loading screen, or login view.
struct RootView: View {
    @State private var userData: [String: Any] = [:]

    var body: some View {
        ZStack {
            if userData.isEmpty {
                LoadingView()
            } else if userData["name"] == nil {
                QuickLoginView(userData: $userData)
            } else {
                MainTabView(userData: userData)
            }
        }
        .task {
            fetchUserData()
        }
    }
    
/// Authenticates the user anonymously with Firebase Auth and attempts to fetch their associated document from Firestore. Then, makes sure to update `userData` accordingly.
    private func fetchUserData() {
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else {
                print("Could not log in")
                return
            }

            let db = Firestore.firestore()
            db.collection("users").document(user.uid).getDocument { snapshot, error in
                if let data = snapshot?.data() {
                    self.userData = data.merging(["id": user.uid]) { $1 }
                } else {
                    self.userData = ["id": user.uid]
                }
            }
        }
    }
}

