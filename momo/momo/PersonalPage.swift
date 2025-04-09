import SwiftUI
import Firebase
import FirebaseFirestore

struct PersonalPage: View {
    @Environment(\.dismiss) var dismiss
    @State private var statusMessage = "No Gym"
    @State private var customMessage = ""
    @State private var friends: [Friend] = []
    

    let userData: [String: Any]
    private let db = Firestore.firestore()
    @AppStorage("userId") private var userId: String?

    

    var userID: String {
        userId ?? "unknown"
    }

    var userName: String {
        userData["name"] as? String ?? "User"
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("My Gym Status")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(userName)
                .font(.headline)

            // 📝 Custom Message Field
            TextField("What's your status message?", text: $customMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onSubmit {
                    saveCustomMessage()
                }
                .onChange(of: customMessage) { _ in
                    saveCustomMessage()
                }

            Circle()
                .fill(Color.purple.opacity(0.3))
                .frame(width: 150, height: 150)
                .padding()

            Text("Current Status: \(statusMessage)")
                .font(.headline)

            // 💪 Status Buttons
            VStack(spacing: 12) {
                Button(action: { updateStatus(status: .inGym) }) {
                    Text("At Gym")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }

                Button(action: { updateStatus(status: .goingToGym) }) {
                    Text("Going to Gym")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }

                Button(action: { updateStatus(status: .notInGym) }) {
                    Text("No Gym")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
            }
            .padding(.horizontal)

            Spacer()

            Button(action: { dismiss() }) {
                Text("Back")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            fetchUserStatus()
        }
    }

    func updateStatus(status: GymStatus) {
        db.collection("users").document(userID).setData([
            "gymStatus": status.rawValue,
            "statusMessage": customMessage
        ], merge: true) { error in
            if let error = error {
                print("❌ Error updating status: \(error)")
            } else {
                DispatchQueue.main.async {
                    statusMessage = status.rawValue
                    print("✅ Gym status updated to \(status.rawValue)")
                }
            }
        }
    }

    func saveCustomMessage() {
        db.collection("users").document(userID).setData([
            "statusMessage": customMessage
        ], merge: true) { error in
            if let error = error {
                print("❌ Error updating custom message: \(error)")
            } else {
                print("✅ Custom message updated: \(customMessage)")
            }
        }
    }

    func fetchUserStatus() {
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                print("❌ Error fetching status: \(error)")
                return
            }

            if let data = snapshot?.data() {
                if let savedStatus = data["gymStatus"] as? String {
                    DispatchQueue.main.async {
                        statusMessage = savedStatus
                        print("✅ Retrieved gym status: \(savedStatus)")
                    }
                }

                if let savedMessage = data["statusMessage"] as? String {
                    DispatchQueue.main.async {
                        customMessage = savedMessage
                        print("✅ Retrieved custom message: \(savedMessage)")
                    }
                }
            }
        }
    }
}

