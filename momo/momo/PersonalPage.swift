import SwiftUI
import Firebase
import FirebaseFirestore

struct PersonalPage: View {
    @Environment(\.dismiss) var dismiss
    @State private var statusMessage = "No Gym"
    @State private var friends: [Friend] = []  // Use existing Friend struct

    private let db = Firestore.firestore()  // Single Firestore instance

    var body: some View {
        VStack {
            Text("My Gym Status")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("Nadiz")
                .font(.headline)
                .padding(.horizontal, -150)
            Text("It's leg day!!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal, -150)

            Circle()
                .fill(Color.purple.opacity(0.3))
                .frame(width: 150, height: 150)
                .padding()
            
            Button(action: { updateStatus(status: .inGym) }) {
                Text("At Gym")
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.green)
                    .cornerRadius(30)
            }

            Button(action: { updateStatus(status: .goingToGym) }) {
                Text("Going to Gym")
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(30)
            }
            .padding(.horizontal, 100)

            Button(action: { updateStatus(status: .notInGym) }) {
                Text("No Gym")
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.red)
                    .cornerRadius(30)
            }
            .padding(.horizontal)

            Spacer()

            Button("Back") {
                dismiss()
            }
            .padding()
        }
        .padding()
   //     .onAppear { fetchFriends() }
    }
    
    enum GymStatus: String {
        case inGym = "At Gym"
        case goingToGym = "Going to Gym"
        case notInGym = "No Gym"
    }


    func updateStatus(status: GymStatus) {
        let userID = "Nadiz"  // Replace with actual user ID from authentication later on
        db.collection("users").document(userID).setData(["gymStatus": status.rawValue]) { error in
            if let error = error {
                print("Error updating status: \(error)")
            } else {
                statusMessage = status.rawValue
            }
        }
    }

    //func fetchFriends() {
       
    }


