import SwiftUI
import FirebaseFirestore

struct QuickLoginView: View {
    @State private var phoneNumber = ""
    @State private var userName = ""
    @State private var showNameField = false
    @State private var error: String?

    var onLoginSuccess: (_ userData: [String: Any]) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Placeholder Mascot Image
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.pink.opacity(0.8))
                .padding(.bottom, 10)

            // App Title
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

            // Input Fields
            VStack(spacing: 16) {
                TextField("Enter phone number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if showNameField {
                    TextField("Enter your name", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }

                if let error = error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                Button(action: handleButtonPress) {
                    Text(showNameField ? "Create Account" : "Continue")
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

    private func handleButtonPress() {
        let formattedPhone = phoneNumber.hasPrefix("+") ? phoneNumber : "+1" + phoneNumber
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(formattedPhone)

        userRef.getDocument { docSnapshot, err in
            if let err = err {
                error = "Error checking user: \(err.localizedDescription)"
                return
            }

            if let data = docSnapshot?.data() {
                onLoginSuccess(data)
            } else if showNameField {
                let newUser = [
                    "name": userName,
                    "phone": formattedPhone,
                    "joined": Timestamp()
                ] as [String: Any]

                userRef.setData(newUser) { error in
                    if let error = error {
                        self.error = "Failed to create user: \(error.localizedDescription)"
                    } else {
                        onLoginSuccess(newUser)
                    }
                }
            } else {
                withAnimation {
                    showNameField = true
                }
            }
        }
    }
}

