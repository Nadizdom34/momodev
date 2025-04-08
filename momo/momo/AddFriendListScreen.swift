import SwiftUI
import FirebaseFirestore

struct AddFriendListScreen: View {
    @Environment(\.dismiss) var dismiss
    let currentUserPhone: String
    @State private var friendPhone = ""
    @State private var errorMessage: String?

    private let db = Firestore.firestore()

    var body: some View {
        NavigationStack {
            Form {
                TextField("Friend's Phone Number", text: $friendPhone)
                    .keyboardType(.phonePad)

                Button("Add Friend by Phone") {
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
        let formattedPhone = friendPhone.hasPrefix("+") ? friendPhone : "+1\(friendPhone)"

        db.collection("users").document(formattedPhone).getDocument { snapshot, error in
            if let error = error {
                errorMessage = "Error finding user: \(error.localizedDescription)"
                return
            }

            guard let data = snapshot?.data(),
                  let _ = data["name"] as? String else {
                errorMessage = "User not found or missing name"
                return
            }

            db.collection("users").document(currentUserPhone)
                .collection("friends").document(formattedPhone)
                .setData(["addedAt": Timestamp()]) { err in
                    if let err = err {
                        errorMessage = "Failed to add friend: \(err.localizedDescription)"
                    } else {
                        print("✅ Added friend: \(formattedPhone)")
                        dismiss()
                    }
                }
        }
    }
}

