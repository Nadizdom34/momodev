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
    let friends = [
        Friend(name: "Alice", status: .inGym),
        Friend(name: "Bob", status: .notInGym),
        Friend(name: "Charlie", status: .goingToGym),
        Friend(name: "David", status: .inGym),
        Friend(name: "Eve", status: .notInGym)
    ]

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
        }
    }
}

#Preview {
    FriendsListScreen()
}
