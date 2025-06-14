import SwiftUI
import FirebaseFirestore

/// Allows users to enter an invite code to add them and generate a user's own unique code to invite others
struct AddFriendListScreen: View {
    @Environment(\.dismiss) var dismiss
    @State private var inputCode = ""
    @State private var errorMessage: String?
    var userId: String?
    @State private var currentCode: String?
    private let db = Firestore.firestore()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 1.0, green: 0.85, blue: 0.95),
                        Color(red: 1.0, green: 0.7, blue: 0.85)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Form {
                    Section(header: Text("Enter Friend Code")) {
                        TextField("6-character code", text: $inputCode)
                            .autocapitalization(.allCharacters)
                        Button(action: addFriendByCode) {
                            Text("Add Friend by Code")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.purple)
                        }
                    }
                        
                    Section(header: Text("Your Invite Code")) {
                        if let userId = userId {
                            Button(action: {
                                generateFriendCode(for: userId)
                            }) {
                                Text("Generate New Code")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.purple)
                            }
                        if let code = currentCode {
                            Text("Code: \(code)")
                            .font(.headline)
                            .contextMenu {
                                Button(action: {
                                    UIPasteboard.general.string = code
                                }) {
                                    Label("Copy", systemImage: "doc.on.doc")
                                }
                            }
                                }
                            }
                        }
                    
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .navigationTitle("Add Friend")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action:{
                        dismiss()
                    }){
                        Text("Cancel")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding(.vertical,10)
                            .padding(.horizontal,16)
                            .background(Color.purple)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

/// Generate's a new 6 character friend code to save it in FireStore and takes in the ID of the current user
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

/// Adds a friend based on the entered invite code
    func addFriendByCode() {
        guard let userId = userId else {
            errorMessage = "Missing user ID"
            return
        }

        let code = inputCode.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if code.isEmpty {
            return
        }

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
    
/// Generates random alphabatized code of the indicated length
    func randomCode(length: Int) -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in characters.randomElement()! })
    }
}
