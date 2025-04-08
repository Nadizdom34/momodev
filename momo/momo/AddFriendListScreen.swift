import SwiftUI
import FirebaseFirestore

struct AddFriendListScreen: View {
    @Environment(\.dismiss) var dismiss
    @Binding var friends: [Friend]
    let currentUserPhone: String

    @State private var friendPhone = ""
    private let db = Firestore.firestore()

    var body: some View {
        NavigationStack {
            Form {
                TextField("Friend's Phone Number", text: $friendPhone)
                    .keyboardType(.phonePad)

                Button("Add Friend by Phone") {
                    searchFriendByPhone()
                }
            }
            .navigationTitle("Add Friend")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    func searchFriendByPhone() {
        let formattedPhone = friendPhone.hasPrefix("+") ? friendPhone : "+1\(friendPhone)"

        db.collection("users").document(formattedPhone).getDocument { docSnapshot, error in
            if let error = error {
                print("❌ Error searching user: \(error)")
                return
            }

            guard let document = docSnapshot, document.exists else {
                print("❌ No user found with phone number")
                return
            }

            let data = document.data() ?? [:]
            guard let name = data["name"] as? String else {
                print("❌ User has no name field")
                return
            }

            let statusString = data["gymStatus"] as? String ?? "No Gym"
            let status = GymStatus(rawValue: statusString) ?? .notInGym
            let friendID = document.documentID

            let friend = Friend(id: friendID, name: name, status: status)

            db.collection("users").document(currentUserPhone).collection("friends").document(friendID).setData([
                "name": friend.name,
                "status": friend.status.rawValue
            ]) { error in
                if let error = error {
                    print("❌ Error saving friend: \(error)")
                } else {
                    DispatchQueue.main.async {
                        friends.append(friend)
                        dismiss()
                    }
                    print("✅ Added friend: \(friend.name)")
                }
            }
        }
    }
}

