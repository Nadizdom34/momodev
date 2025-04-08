import SwiftUI
import FirebaseFirestore

struct FriendsListScreen: View {
    let currentUserPhone: String
    @State private var friends: [Friend] = []
    @State private var showAddFriend = false
    private let db = Firestore.firestore()
    @State private var listener: ListenerRegistration?

    var body: some View {
        NavigationStack {
            List(friends) { friend in
                HStack {
                    Text(friend.name)
                    Spacer()
                    Text(friend.status.rawValue)
                        .foregroundColor(friend.status.color)
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        showAddFriend = true
                    }
                }
            }
            .sheet(isPresented: $showAddFriend) {
                AddFriendListScreen(friends: $friends, currentUserPhone: currentUserPhone)
            }
            .onAppear {
                startListeningForFriends()
            }
            .onDisappear {
                listener?.remove()
            }
        }
    }

    func startListeningForFriends() {
        listener?.remove()  // In case already listening
        listener = db.collection("users").document(currentUserPhone).collection("friends")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Error listening for friends: \(error)")
                    return
                }

                self.friends = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    guard let name = data["name"] as? String,
                          let statusString = data["status"] as? String,
                          let status = GymStatus(rawValue: statusString) else {
                        return nil
                    }
                    return Friend(id: doc.documentID, name: name, status: status)
                } ?? []
            }
    }
}

