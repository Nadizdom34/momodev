import SwiftUI
import FirebaseFirestore

struct AddFriendListScreen: View {
    @Environment(\ .dismiss) var dismiss
    @State private var friendId = ""
    @State private var errorMessage: String?
    @AppStorage("userId") private var userId: String?
    private let db = Firestore.firestore()

    var body: some View {
        NavigationStack {
            Form {
                TextField("Friend's User ID", text: $friendId)

                Button("Add Friend by ID") {
                    addFriend()
                }

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Add Friend")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    func addFriend() {
        guard let userId = userId, !userId.isEmpty else {
            errorMessage = "Invalid user ID"
            return
        }

        db.collection("users").document(friendId).getDocument { snapshot, error in
            if let error = error {
                errorMessage = "Error finding user: \(error.localizedDescription)"
                return
            }

            guard let data = snapshot?.data(),
                  let _ = data["name"] as? String else {
                errorMessage = "User not found or missing name"
                return
            }

            db.collection("users").document(userId)
                .collection("friends").document(friendId)
                .setData(["addedAt": Timestamp()]) { err in
                    if let err = err {
                        errorMessage = "Failed to add friend: \(err.localizedDescription)"
                    } else {
                        print("✅ Added friend: \(friendId)")
                        dismiss()
                    }
                }
        }
    }
}

