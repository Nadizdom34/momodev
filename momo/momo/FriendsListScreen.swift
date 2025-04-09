import SwiftUI
import FirebaseFirestore

struct FriendsListScreen: View {

    let currentUserPhone: String
    @State private var friendsDict: [String: Friend] = [:]
    @State private var showAddFriend = false

    private let db = Firestore.firestore()
    @State private var listeners: [ListenerRegistration] = []
    @AppStorage("userId") private var userId: String?


    var body: some View {
        NavigationStack {
            List(Array(friendsDict.values).sorted(by: { $0.name < $1.name }), id: \.id) { friend in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(friend.name)
                            .font(.headline)
                        Spacer()
                        Text(friend.status.rawValue)
                            .foregroundColor(friend.status.color)
                    }

                    if let message = friend.message, !message.isEmpty {
                        Text("“\(message)”")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 6)
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
                AddFriendListScreen(currentUserPhone: currentUserPhone)
            }
            .onAppear {
                listenToFriends()
            }
            .onDisappear {
                removeAllListeners()
            }
        }
    }

    func listenToFriends() {
        removeAllListeners()

        db.collection("users").document(currentUserPhone).collection("friends")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Error listening to friend list: \(error)")
                    return
                }

                guard let docs = snapshot?.documents else { return }

                for doc in docs {
                    let friendID = doc.documentID

                    let listener = db.collection("users").document(friendID)
                        .addSnapshotListener { snap, error in
                            if let error = error {
                                print("❌ Error listening to friend profile: \(error)")
                                return
                            }

                            guard let data = snap?.data(),
                                  let name = data["name"] as? String,
                                  let statusRaw = data["gymStatus"] as? String,
                                  let status = GymStatus(rawValue: statusRaw) else {
                                print("⚠️ Skipping friend \(friendID) due to missing or invalid data")
                                return
                            }

                            let message = data["statusMessage"] as? String ?? ""

                            DispatchQueue.main.async {
                                friendsDict[friendID] = Friend(
                                    id: friendID,
                                    name: name,
                                    status: status,
                                    message: message
                                )
                            }
                        }

                    listeners.append(listener)
                }
            }
    }

    func removeAllListeners() {
        listeners.forEach { $0.remove() }
        listeners.removeAll()
    }
}

