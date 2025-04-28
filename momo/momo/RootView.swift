import SwiftUI
import FirebaseFirestore

//The root navigation logic for the app, handles whether to show the main app, loading screen, or login view.
struct RootView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false //Tracks the login status
    @AppStorage("userName") private var userName: String = "" //Stored username
    @AppStorage("userId") private var userId: String? //Stored user ID

    //User data that is fetched from Firestore
    @State private var userData: [String: Any]?

    var body: some View {
        if isLoggedIn {
            if let userData = userData {
                //Indicates user is logged in, loads their data, and displays main tabs of app
                MainTabView(userData: userData)
            } else {
                //Indicates user is loggen in, but still fetching data
                LoadingView()
                    .onAppear(perform: fetchUserData)
            }
        } else {
            //Indicates user is not logged in, show log-in screen
            QuickLoginView { data in
                self.userData = data
                self.isLoggedIn = true
            }
        }
    }
    //Fecthes the user data from Firestore based on the stored user ID
    private func fetchUserData() {
        guard let unwrappedUserId = userId, !unwrappedUserId.isEmpty else {
            print(" Missing or empty userId – logging out.")
            self.isLoggedIn = false
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(unwrappedUserId).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                // Adds the documentID to the user's ID for future use of updating user's data
                self.userData = data.merging(["id": unwrappedUserId]) { $1 }
            } else {
                print("Failed to fetch user data: \(error?.localizedDescription ?? "unknown error")")
                self.isLoggedIn = false
            }
        }
    }
}

