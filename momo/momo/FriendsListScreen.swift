import SwiftUI
import FirebaseFirestore
import FirebaseFunctions

struct FriendsListScreen: View {
    @State private var friendsDict: [String: Friend] = [:]
    @State private var showAddFriend = false
    private let db = Firestore.firestore()
    @State private var listeners: [ListenerRegistration] = []
    @AppStorage("userId") private var userId: String?

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
                            Text("\"\(message)\"")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Button(action: {
                            sendGymPing(to: friend.id)
                        }) {
                            Text("Notify: I'm at the gym")
                                .font(.caption)
                                .foregroundColor(.blue)
                                .padding(.top, 4)
                        }
                    }
                    .padding(.vertical, 6)
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden) 
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
                AddFriendListScreen()
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
        guard let userId = userId, !userId.isEmpty else { return }
        removeAllListeners()

        db.collection("users").document(userId).collection("friends")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening to friend list: \(error)")
                    return
                }

                guard let docs = snapshot?.documents else { return }

                for doc in docs {
                    let friendID = doc.documentID

                    let listener = db.collection("users").document(friendID)
                        .addSnapshotListener { snap, error in
                            if let error = error {
                                print("Error listening to friend profile: \(error)")
                                return
                            }

                            guard let data = snap?.data(),
                                  let name = data["name"] as? String,
                                  let statusRaw = data["gymStatus"] as? String,
                                  let status = GymStatus(rawValue: statusRaw) else {
                                print("Skipping friend \(friendID) due to missing or invalid data")
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

    func sendGymPing(to friendId: String) {
        Functions.functions().httpsCallable("sendGymPing").call(["friendId": friendId]) { result, error in
            if let error = error {
                print("Failed to send gym ping: \(error.localizedDescription)")
            } else {
                print("Sent gym ping to \(friendId)")
            }
        }
    }
}

