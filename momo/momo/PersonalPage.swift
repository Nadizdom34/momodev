import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import RiveRuntime

// Personal Page Screen where the user can update gym status, status message, and profile picture
struct PersonalPage: View {
    @Environment(\.dismiss) var dismiss
    @State private var statusMessage = "No Gym"
    @State private var customMessage = ""
    @State private var friends: [Friend] = []
    
    @State private var selectedImageIndex = 0
    @State private var selectedStatus: GymStatus? = nil
    
    @State private var showBubble = false
    @State private var bubbleText = ""
    @State private var keyboardHeight: CGFloat = 0 // 👈 Added to your view


    let profileImages = ["sleepy cat", "gym cat", "walking cat"]
    //Getting the data for that user from firestore
    let userData: [String: Any]
    private let db = Firestore.firestore()

    //User's information:
    var userID: String {
        userData["id"] as? String ?? "unknown"
    }
    var remainingCharacters: Int {
        max(0, 50 - customMessage.count)
    }
    
    let characterAnimation = RiveViewModel(fileName: "momo_done")

    var body: some View {
        ZStack {
            // Background UI
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.6, green: 0.4, blue: 0.9),
                    Color(red: 1.0, green: 0.7, blue: 0.85)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

//            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    characterAnimation.view()
                        .frame(width: 400, height: 400)
                        .shadow(radius: 5)

                    // Gym Status Buttons
                    HStack{
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
                        .padding(.horizontal, 16)
                    }

                    // Status Message Section
                    HStack{
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
                            //Setting up restrictions for message character length
                            HStack {
                                Spacer()
                                Text("\(remainingCharacters) characters left")
                                    .font(.caption2)
                                    .foregroundColor(remainingCharacters <= 5 ? .red : .gray)
                            }
                            //Delete Status Message
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
                                    //Updating custom status message
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
                    }
                    .padding(.horizontal, 16)

//                    // Logout Button
//                    Button(action: {
//                        logOut()
//                    }) {
//                        Text("Log Out")
//                            .font(.footnote)
//                            .foregroundColor(.red)
//                            .padding(.top, 4)
//                    }

                    Spacer()
                          }
                          .padding()
                          .padding(.bottom, keyboardHeight) // 👈 This moves the layout when keyboard appears
                          .animation(.easeOut(duration: 0.25), value: keyboardHeight) // 👈 Smooth transition
                          .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                              if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                                  keyboardHeight = keyboardFrame.height
                              }
                          }
                          .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                              keyboardHeight = 0
                          }
                          .gesture(
                            TapGesture().onEnded { _ in
                                dismissKeyboard()
                            }
                        )
                      }
                      .onAppear {
                          fetchUserStatus()
                      }
                  }
                func dismissKeyboard() {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }

    //Used for leaderboard to see if user has checked into the gym
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
    //UI for the "sent" bubble when user's custom status message is updated
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
    //Updates the users gym status and status message to firestore
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
    //Updates and saves the user's custom message in firestore
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
    //Deletes a user's status message and updates firestore
    func deleteStatusMessage() {
        customMessage = ""
        db.collection("users").document(userID).updateData([
            "statusMessage": FieldValue.delete()
        ]) { error in
            if let error = error {
                print("Error deleting status message: \(error.localizedDescription)")
            } else {
                showFloatingBubble(with: "Deleted")
                print("Successfully deleted status message")
            }
        }
    }
    //Gets the user's updated status information from the firestore
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

    //Handles log-out for a user when button is pressed.
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
