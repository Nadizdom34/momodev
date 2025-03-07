//
//  Friend.swift
//  momo
//
//  Created by William Acosta on 3/7/25.
//


import SwiftUI

struct Friend: Identifiable {
    let id = UUID()
    let name: String
    let status: GymStatus
}

enum GymStatus {
    case inGym, notInGym, goingToGym

    var description: String {
        switch self {
        case .inGym: return "In Gym"
        case .notInGym: return "Not in Gym"
        case .goingToGym: return "Going to the Gym"
        }
    }

    var color: Color {
        switch self {
        case .inGym: return .green
        case .notInGym: return .red
        case .goingToGym: return .yellow
        }
    }
}

struct FriendsListScreen: View {
    @Environment(\.dismiss) var dismiss  // Allows dismissing the screen
    @State private var friends = [
        Friend(name: "William", status: .inGym),
        Friend(name: "Bob", status: .notInGym),
        Friend(name: "Charlie", status: .goingToGym),
        Friend(name: "David", status: .inGym),
        Friend(name: "Eve", status: .notInGym)
    ]
    
    @State private var showAddFriendScreen = false  // Controls add friend modal

    var body: some View {
        NavigationStack {
            List(friends) { friend in
                HStack {
                    Text(friend.name)
                        .font(.headline)
                    Spacer()
                    Text(friend.status.description)
                        .foregroundColor(friend.status.color)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Friends' Gym Status")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        dismiss()  // Close the screen
                    }
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Friend") {
                        showAddFriendScreen = true  // Show add friend screen
                    }
                    .foregroundColor(.blue)
                }
            }
            .sheet(isPresented: $showAddFriendScreen) {
                AddFriendScreen(friends: $friends)  // Present add friend screen
            }
        }
    }
}

struct AddFriendScreen: View {
    @Environment(\.dismiss) var dismiss
    @Binding var friends: [Friend]
    
    @State private var newFriendName = ""
    @State private var selectedStatus: GymStatus = .notInGym
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Friend's Name", text: $newFriendName)
                
                Picker("Status", selection: $selectedStatus) {
                    Text("In Gym").tag(GymStatus.inGym)
                    Text("Not in Gym").tag(GymStatus.notInGym)
                    Text("Going to the Gym").tag(GymStatus.goingToGym)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .navigationTitle("Add Friend")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if !newFriendName.isEmpty {
                            let newFriend = Friend(name: newFriendName, status: selectedStatus)
                            friends.append(newFriend)
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FriendsListScreen()
}

