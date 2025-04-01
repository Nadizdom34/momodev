import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

struct Friend: Identifiable {
    let id: String  // Firestore document ID
    let name: String
    let status: GymStatus
}

enum GymStatus: String, CaseIterable {
    case inGym = "In Gym"
    case notInGym = "Not in Gym"
    case goingToGym = "Going to the Gym"

    var color: Color {
        switch self {
        case .inGym: return .green
        case .notInGym: return .red
        case .goingToGym: return .yellow
        }
    }
}

struct FriendsListScreen: View {
    @Environment(\.dismiss) var dismiss
    @State private var friends: [Friend] = []
    @State private var showAddFriendScreen = false
    private let db = Firestore.firestore()

    var body: some View {
        NavigationStack {
            List(friends) { friend in
                HStack {
                    Text(friend.name)
                        .font(.headline)
                    Spacer()
                    Text(friend.status.rawValue)
                        .foregroundColor(friend.status.color)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Friends' Gym Status")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") { dismiss() }
                        .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Friend") { showAddFriendScreen = true }
                        .foregroundColor(.blue)
                }
            }
            .sheet(isPresented: $showAddFriendScreen) {
                AddFriendScreen(friends: $friends)
            }
            .onAppear {
                fetchFriendsFromFirestore()
            }
        }
    }

    // ✅ Fetch friends from Firestore
    func fetchFriendsFromFirestore() {
        let userID = "Nadiz"  // Replace with actual user authentication ID

        db.collection("users").document(userID).collection("friends")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching friends: \(error)")
                    return
                }

                DispatchQueue.main.async {
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
}

struct AddFriendScreen: View {
    @Environment(\.dismiss) var dismiss
    @Binding var friends: [Friend]
    
    @State private var newFriendName = ""
    @State private var selectedStatus: GymStatus = .notInGym
    private let db = Firestore.firestore()

    var body: some View {
        NavigationStack {
            Form {
                TextField("Friend's Name", text: $newFriendName)

                Picker("Status", selection: $selectedStatus) {
                    ForEach(GymStatus.allCases, id: \.self) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .navigationTitle("Add Friend")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { saveFriendToFirestore() }
                        .disabled(newFriendName.isEmpty)
                }
            }
        }
    }

    // ✅ Save new friend to Firestore
    func saveFriendToFirestore() {
        let userID = "Nadiz"  // Replace with actual user authentication ID
        let friendData: [String: Any] = [
            "name": newFriendName,
            "status": selectedStatus.rawValue
        ]

        db.collection("users").document(userID).collection("friends")
            .addDocument(data: friendData) { error in
                if let error = error {
                    print("❌ Error adding friend: \(error)")
                } else {
                    DispatchQueue.main.async {
                        let newFriend = Friend(id: UUID().uuidString, name: newFriendName, status: selectedStatus)
                        friends.append(newFriend)
                        dismiss()
                    }
                    print("✅ Friend \(newFriendName) added successfully!")
                }
            }
    }
}

#Preview {
    FriendsListScreen()
}

