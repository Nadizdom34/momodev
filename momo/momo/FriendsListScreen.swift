import SwiftUI
import FirebaseFirestore
import FirebaseFunctions

// Displays the user's friends in a list view
// Receives real-time updates from Firestore
// Handles adding friends to the current user's friend list
struct FriendsListScreen: View {
    @State private var friendsDict: [String: Friend] = [:]
    @State private var showAddFriend = false
    private let db = Firestore.firestore()
    @State private var listeners: [ListenerRegistration] = []
    @AppStorage("userId") private var userId: String?

    var body: some View {
        NavigationStack {
            ZStack {
                // Background UI
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 1.0, green: 0.85, blue: 0.95), // blush pink
                        Color(red: 1.0, green: 0.7, blue: 0.85)   // soft rose
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                // Friend's List
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
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.7), lineWidth: 1.5) // Soft white border
                            .background(Color.white.opacity(0.15)) // Light inner background
                            .cornerRadius(12)
                    )
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

    // Sets up Firestore listeners to keep track of updates to a user's friends list and friend's statuses
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

    // Removes all listeners to prevent memory leaks
    func removeAllListeners() {
        listeners.forEach { $0.remove() }
        listeners.removeAll()
    }
}
