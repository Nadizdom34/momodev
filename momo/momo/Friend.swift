import SwiftUI
import FirebaseAuth
import FirebaseFirestore

//Represents friend, sets up variables that will be shown on friends list UI.
struct Friend: Identifiable, Hashable {
    let id: String
    let name: String
    let status: GymStatus
    let message: String?
}
//Handles adding a friend on screen and stores to Firebase
struct AddFriendScreen: View {
    @Environment(\.dismiss) var dismiss
    @Binding var friends: [Friend]
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
    //Searches for a friend by phone number in Firestore and adds them to the current user's friends' list
    func searchFriendByPhone() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print(" User is not authenticated")
            return
        }

        let formattedPhone = friendPhone.hasPrefix("+") ? friendPhone : "+1\(friendPhone)"

        db.collection("users").whereField("phone", isEqualTo: formattedPhone)
            .getDocuments { snapshot, error in
                if let error = error {
                    print(" Error searching user: \(error)")
                    return
                }

                guard let document = snapshot?.documents.first else {
                    print(" No user found with phone number")
                    return
                }

                let data = document.data()
                guard let name = data["name"] as? String,
                      let statusString = data["gymStatus"] as? String,
                      let status = GymStatus(rawValue: statusString) else {
                    print(" Invalid user data")
                    return
                }

                let message = data["statusMessage"] as? String
                let friend = Friend(id: document.documentID, name: name, status: status, message: message)

                db.collection("users").document(userID).collection("friends")
                    .document(friend.id).setData([
                        "name": friend.name,
                        "status": friend.status.rawValue,
                        "message": message ?? ""
                    ]) { error in
                        if let error = error {
                            print(" Error saving friend: \(error)")
                        } else {
                            DispatchQueue.main.async {
                                friends.append(friend)
                                dismiss()
                            }
                            print(" Added friend: \(friend.name)")
                        }
                    }
            }
    }
}

