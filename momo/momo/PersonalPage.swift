import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

// Personal Page Screen
struct PersonalPage: View {
    @Environment(\.dismiss) var dismiss
    @State private var statusMessage = "No Gym"
    @State private var customMessage = ""
    @State private var friends: [Friend] = []
    @State private var selectedImageIndex = 0
    @State private var selectedStatus: GymStatus? = nil // Track selected gym status

    let profileImages = ["sleepy cat", "gym cat", "walking cat"]
    let userData: [String: Any]
    private let db = Firestore.firestore()

    @State private var showBubble = false
    @State private var bubbleText = ""

    var userID: String {
        userData["id"] as? String ?? "unknown"
    }
    var userName: String {
        userData["name"] as? String ?? "User"
    }
    var remainingCharacters: Int {
        max(0, 50 - customMessage.count)
    }

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.6, green: 0.4, blue: 0.9),
                    Color(red: 1.0, green: 0.7, blue: 0.85)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    VStack(spacing: 12) {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 160, height: 160)
                            .overlay(
                                Image(profileImages[selectedImageIndex])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 90)
                            )
                            .shadow(radius: 8)

                        Picker("Select Profile Image", selection: $selectedImageIndex) {
                            ForEach(0..<profileImages.count, id: \.self) { index in
                                Image(profileImages[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)

                        Text(userName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }

                    // Gym Status Buttons
                    VStack(spacing: 12) {
                        Text("Your Gym Status")
                            .font(.headline)
                            .foregroundColor(.white)

                        HStack(spacing: 10) {
                            StatusButton(
                                title: "No Gym",
                                isSelected: selectedStatus == .notInGym,
                                color: Color(red: 1.0, green: 0.6, blue: 0.6)
                            ) {
                                updateStatus(status: .notInGym)
                                selectedStatus = .notInGym
                            }

                            StatusButton(
                                title: "Going",
                                isSelected: selectedStatus == .goingToGym,
                                color: Color(red: 1.0, green: 0.8, blue: 0.6)
                            ) {
                                updateStatus(status: .goingToGym)
                                selectedStatus = .goingToGym
                            }

                            StatusButton(
                                title: "At Gym",
                                isSelected: selectedStatus == .inGym,
                                color: Color(red: 0.7, green: 1.0, blue: 0.7)
                            ) {
                                updateStatus(status: .inGym)
                                selectedStatus = .inGym
                            }
                        }
                    }

                    // Status Message Section
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Your Status Message")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        TextField("What's your status message?", text: $customMessage)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: customMessage) { newValue in
                                if newValue.count > 50 {
                                    customMessage = String(newValue.prefix(50))
                                }
                            }

                        HStack {
                            Spacer()
                            Text("\(remainingCharacters) characters left")
                                .font(.caption2)
                                .foregroundColor(remainingCharacters <= 5 ? .red : .gray)
                        }

                        ZStack {
                            HStack(spacing: 8) {
                                Button(action: {
                                    deleteStatusMessage()
                                }) {
                                    Text("Clear")
                                        .font(.caption)
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color(red: 1.0, green: 0.7, blue: 0.8)) // pastel pink
                                        .cornerRadius(6)
                                }

                                Spacer()

                                Button(action: {
                                    saveCustomMessage()
                                }) {
                                    Text("Update")
                                        .font(.caption)
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color(red: 0.8, green: 0.7, blue: 1.0)) // pastel lavender
                                        .cornerRadius(6)
                                }
                            }

                            if showBubble {
                                Text(bubbleText)
                                    .font(.caption2)
                                    .padding(6)
                                    .background(Color.black.opacity(0.85))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .transition(.opacity.combined(with: .scale))
                                    .offset(y: -5)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)

                    // Logout Button
                    Button(action: {
                        logOut()
                    }) {
                        Text("Log Out")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.top, 4)
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            fetchUserStatus()
        }
    }

    // --- Functions ---
    func recordCheckIn() {
        let checkInData: [String: Any] = ["timestamp": Timestamp(date: Date())]
        db.collection("checkins")
            .document(self.userID)
            .collection("userCheckins")
            .addDocument(data: checkInData) { error in
                if let error = error {
                    print("Error recording check-in: \(error.localizedDescription)")
                } else {
                    print("Successfully recorded a check-in")
                }
            }
    }

    func showFloatingBubble(with text: String) {
        bubbleText = text
        withAnimation {
            showBubble = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showBubble = false
            }
        }
    }

    func updateStatus(status: GymStatus) {
        db.collection("users").document(userID).setData([
            "gymStatus": status.rawValue,
            "statusMessage": customMessage
        ], merge: true) { error in
            if let error = error {
                print("Error updating status: \(error)")
            } else {
                DispatchQueue.main.async {
                    statusMessage = status.rawValue
                    print("Gym status updated to \(status.rawValue)")
                }
                if status == .inGym {
                    recordCheckIn()
                }
            }
        }
    }

    func saveCustomMessage() {
        db.collection("users").document(userID).setData([
            "statusMessage": customMessage
        ], merge: true) { error in
            if let error = error {
                print("Error updating custom message: \(error)")
            } else {
                showFloatingBubble(with: "Sent")
                print("Custom message updated: \(customMessage)")
            }
        }
    }

    func deleteStatusMessage() {
        customMessage = ""
        db.collection("users").document(userID).updateData([
            "statusMessage": FieldValue.delete()
        ]) { error in
            if let error = error {
                print("Error deleting status message: \(error.localizedDescription)")
            } else {
                showFloatingBubble(with: "Deleted 🗑️")
                print("Successfully deleted status message")
            }
        }
    }

    func fetchUserStatus() {
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching status: \(error)")
                return
            }
            if let data = snapshot?.data() {
                if let savedStatus = data["gymStatus"] as? String {
                    DispatchQueue.main.async {
                        statusMessage = savedStatus
                        selectedStatus = GymStatus(rawValue: savedStatus)
                        print("Retrieved gym status: \(savedStatus)")
                    }
                }
                if let savedMessage = data["statusMessage"] as? String {
                    DispatchQueue.main.async {
                        customMessage = savedMessage
                        print("Retrieved custom message: \(savedMessage)")
                    }
                }
            }
        }
    }

    func logOut() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        do {
            try Auth.auth().signOut()
            print("Signed out successfully")
        } catch {
            print("Sign out error: \(error.localizedDescription)")
        }
    }
}

// --- Reusable StatusButton ---
struct StatusButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(isSelected ? color : Color.gray.opacity(0.4))
                .foregroundColor(.black)
                .cornerRadius(10)
        }
    }
}
