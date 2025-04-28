//
//  LeaderboardViewModel.swift
//  momo
//
//  Created by Karla Martinez on 4/28/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct LeaderboardEntry: Identifiable {
    let id: String 
    let userName: String
    let checkInCount: Int
}

class LeaderboardViewModel: ObservableObject {
    @Published var leaderboard: [LeaderboardEntry] = []
    @Published var currentUserCheckIns: Int = 0

    private var db = Firestore.firestore()
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }

    func fetchLeaderboard() {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!

        db.collection("checkins").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }

            var checkInCounts: [String: Int] = [:]
            let dispatchGroup = DispatchGroup()

            for doc in documents {
                let userId = doc.documentID
                let checkInsRef = self.db.collection("checkins").document(userId).collection("userCheckins")

                dispatchGroup.enter()
                checkInsRef.whereField("timestamp", isGreaterThan: oneWeekAgo)
                    .getDocuments { checkinSnapshot, _ in
                        let count = checkinSnapshot?.documents.count ?? 0
                        checkInCounts[userId] = count
                        dispatchGroup.leave()
                    }
            }

            dispatchGroup.notify(queue: .main) {
                self.buildLeaderboard(from: checkInCounts)
            }
        }
    }

    private func buildLeaderboard(from counts: [String: Int]) {
        var entries: [LeaderboardEntry] = []

        for (userId, count) in counts {
            let shortName = "User \(userId.prefix(5))" // You can replace with real username later
            entries.append(LeaderboardEntry(id: userId, userName: shortName, checkInCount: count))
        }

        entries.sort { $0.checkInCount > $1.checkInCount }
        self.leaderboard = entries

        if let uid = userId {
            self.currentUserCheckIns = counts[uid] ?? 0
        }
    }
}


