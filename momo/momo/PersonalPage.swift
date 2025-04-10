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

    var userID: String {
        userData["phone"] as? String ?? "unknown"
    }

    var userName: String {
        userData["name"] as? String ?? "User"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 16) {
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: 180, height: 180) // Increased size
                        .overlay(
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100) // Increased image size
                                .foregroundColor(.purple)
                        )
                        .shadow(radius: 10)

                    Text(userName)
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Current Status: \(statusMessage)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }

                // Custom Message Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Status Message")
                        .font(.headline)

                    TextField("What's your status message?", text: $customMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            saveCustomMessage()
                        }
                        .onChange(of: customMessage) { _ in
                            saveCustomMessage()
                        }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // Gym Status Buttons
                VStack(spacing: 16) {
                    Text("Set Your Gym Status")
                        .font(.headline)

                    HStack(spacing: 12) {
                        StatusButton(title: "At Gym", color: .green) {
                            updateStatus(status: .inGym)
                        }
                        StatusButton(title: "Going", color: .orange) {
                            updateStatus(status: .goingToGym)
                        }
                        StatusButton(title: "No Gym", color: .red) {
                            updateStatus(status: .notInGym)
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
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

struct StatusButton: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.medium)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
}
