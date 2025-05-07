import SwiftUI
import FirebaseFirestore
import FirebaseAuth

//The root navigation logic for the app, handles whether to show the main app, loading screen, or login view.
struct RootView: View {
    //User data that is fetched from Firestore
    @State private var userData: [String: Any]?

    var body: some View {
        ZStack {
            if let userData {
                //Indicates user is logged in, loads their data, and displays main tabs of app
                MainTabView(userData: userData)
            } else {
                //Indicates user is loggen in, but still fetching data
                LoadingView()
            }
        }
        .task {
            fetchUserData()
        }
    }
    //Fecthes the user data from Firestore based on the stored user ID
    private func fetchUserData() {
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else {
                print("Could not log in")
                return
            }

            let db = Firestore.firestore()
            db.collection("users").document(user.uid).getDocument { snapshot, error in
                if let data = snapshot?.data() {
                    // Adds the documentID to the user's ID for future use of updating user's data
                    self.userData = data.merging(["id": user.uid]) { $1 }
                } else {
                    // New user!
                    self.userData = ["id": user.uid]
                }
            }
        }
    }
}

