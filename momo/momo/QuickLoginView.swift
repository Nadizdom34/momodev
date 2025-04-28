import SwiftUI
import FirebaseFirestore
import FirebaseAuth

//Provides login interface for user's and checks with Firestore for existing users or create a new one
//Stores the users ID and username in @AppDelegate for persistance
struct QuickLoginView: View {
    @State private var userName = ""
    @State private var error: String?
    //Checks if user is already logged in
    var isLoggedIn: Bool {
        userId != nil
    }
    //Persisted userID and username across app sessions
    @AppStorage("userId") private var userId: String?
    @AppStorage("userName") private var storedUserName: String = ""

    //Passes user data if login in succesfull
    var onLoginSuccess: (_ userData: [String: Any]) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            //Welcome UI
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.pink.opacity(0.8))
                .padding(.bottom, 10)
            //Setting up UI for log in screen
            Text("Welcome to")
                .font(.title2)
                .foregroundColor(.gray)
            Text("Momo Fit")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.pink)
            Text("Connect with friends for your fitness journey 💪")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
            //User Input
            VStack(spacing: 16) {
                TextField("Enter your name", text: $userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if let error = error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                //Login Button
                Button(action: handleLogin) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(
                            gradient: Gradient(colors: [Color.pink, Color.pink.opacity(0.7)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
            }

            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
    }
    //Handles a user's login or creating new account based on username
    private func handleLogin() {
        guard !userName.isEmpty else {
            error = "Please enter your name"
            return
        }
        //Accessing user's
        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        //Checking if there is already a user with username entered
        usersRef.whereField("name", isEqualTo: userName).getDocuments { snapshot, err in
            if let err = err {
                self.error = "Error checking existing users: \(err.localizedDescription)"
                return
            }

            if let doc = snapshot?.documents.first {
                // Existing user found, so reuse it
                userId = doc.documentID
                storedUserName = userName

                var existingData = doc.data()
                existingData["id"] = userId
                onLoginSuccess(existingData)
            } else {
                // No existing user is found, so creates a new user
                let newUserRef = usersRef.document()
                let userData: [String: Any] = [
                    "name": userName,
                    "joined": Timestamp(),
                    "gymStatus": GymStatus.notInGym.rawValue,
                    "statusMessage": ""
                ]
                //Sets the user's data if succesfull login/account creation
                newUserRef.setData(userData) { err in
                    if let err = err {
                        self.error = "Failed to create user: \(err.localizedDescription)"
                    } else {
                        userId = newUserRef.documentID
                        storedUserName = userName

                        var finalData = userData
                        finalData["id"] = userId
                        onLoginSuccess(finalData)
                    }
                }
            }
        }
    }
}

