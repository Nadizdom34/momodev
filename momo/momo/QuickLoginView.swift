import SwiftUI
import FirebaseFirestore

struct QuickLoginView: View {
    @State private var userName = ""
    @State private var error: String?

    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("userId") private var userId: String = ""
    @AppStorage("userName") private var storedUserName: String = ""

    var onLoginSuccess: (_ userData: [String: Any]) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.pink.opacity(0.8))
                .padding(.bottom, 10)

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

            VStack(spacing: 16) {
                TextField("Enter your name", text: $userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if let error = error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

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

    private func handleLogin() {
        guard !userName.isEmpty else {
            error = "Please enter your name"
            return
        }

        let db = Firestore.firestore()
        let newUserRef = db.collection("users").document() // Auto-ID
        let userData: [String: Any] = [
            "name": userName,
            "joined": Timestamp()
        ]

        newUserRef.setData(userData) { err in
            if let err = err {
                self.error = "Failed to create user: \(err.localizedDescription)"
            } else {
                userId = newUserRef.documentID
                storedUserName = userName
                isLoggedIn = true

                var finalData = userData
                finalData["id"] = userId
                onLoginSuccess(finalData)
            }
        }
    }
}

