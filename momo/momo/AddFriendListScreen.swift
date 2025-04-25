import SwiftUI
import FirebaseFirestore

struct AddFriendListScreen: View {
    @Environment(\.dismiss) var dismiss
    @State private var inputCode = ""
    @State private var errorMessage: String?
    @AppStorage("userId") private var userId: String?
    @State private var currentCode: String?

    private let db = Firestore.firestore()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 1.0, green: 0.85, blue: 0.95), // blush pink
                        Color(red: 1.0, green: 0.7, blue: 0.85)   // soft rose
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Form {
                    Section(header: Text("Enter Friend Code")) {
                        TextField("6-character code", text: $inputCode)
                            .autocapitalization(.allCharacters)

                        Button("Add Friend by Code") {
                            addFriendByCode()
                        }
                    }

                    Section(header: Text("Your Invite Code")) {
                        if let userId = userId {
                            Button("Generate New Code") {
                                generateFriendCode(for: userId)
                            }

                            if let code = currentCode {
                                Text("Code: \(code)")
                                    .font(.headline)
                            }
                        }
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .scrollContentBackground(.hidden) // Hide default white background
                .background(Color.clear)
            }
            .navigationTitle("Add Friend")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    func generateFriendCode(for userId: String) {
        let code = randomCode(length: 6)
        let expiration = Timestamp(date: Date().addingTimeInterval(300)) // 5 minutes

        db.collection("friendCodes").document(code).setData([
            "creatorId": userId,
            "createdAt": Timestamp(),
            "expiresAt": expiration
        ]) { error in
            if let error = error {
                errorMessage = "Failed to generate code: \(error.localizedDescription)"
            } else {
                currentCode = code
                print(" Generated invite code: \(code)")
            }
        }
    }

    func addFriendByCode() {
        guard let userId = userId else {
            errorMessage = "Missing user ID"
            return
        }

        let code = inputCode.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)

        db.collection("friendCodes").document(code).getDocument { snapshot, error in
            if let error = error {
                errorMessage = "Error checking code: \(error.localizedDescription)"
                return
            }

            guard let data = snapshot?.data(),
                  let creatorId = data["creatorId"] as? String,
                  let expiresAt = data["expiresAt"] as? Timestamp else {
                errorMessage = "Invalid or expired code"
                return
            }

            let now = Date()
            guard expiresAt.dateValue() > now else {
                errorMessage = "This code has expired"
                return
            }

            if creatorId == userId {
                errorMessage = "You can't add yourself"
                return
            }

            db.collection("users").document(userId)
                .collection("friends").document(creatorId)
                .setData(["addedAt": Timestamp()]) { err in
                    if let err = err {
                        errorMessage = "Failed to add friend: \(err.localizedDescription)"
                    } else {
                        print(" Added friend from code: \(creatorId)")
                        dismiss()
                    }
                }
        }
    }

    func randomCode(length: Int) -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in characters.randomElement()! })
    }
}
