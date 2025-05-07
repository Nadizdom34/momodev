import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct QuickLoginView: View {
    @State private var userName = ""
    @State private var error: String?
    
    @Binding var userData: [String: Any]
//    var isLoggedIn: Bool {
//        userId != nil
//    }
    
//    @AppStorage("userId") private var userId: String?
//    @AppStorage("userName") private var storedUserName: String = ""
    
//    var onLoginSuccess: (_ userData: [String: Any]) -> Void
    
    var body: some View {
        ZStack {
            // Purple Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.85, green: 0.80, blue: 0.95),
                    Color(red: 0.7, green: 0.6, blue: 0.95)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                // Welcome Icon
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(radius: 10)
                    .padding(.bottom, 10)
                
                // Welcome Texts
                VStack(spacing: 8) {
                    Text("Welcome to")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("Momo Fit")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Connect with friends for your fitness journey ")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Username Input
                VStack(spacing: 16) {
                    TextField("Enter your name", text: $userName)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .shadow(radius: 5)
                    
                    if let error = error {
                        Text(error)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    Button(action: handleLogin) {
                        Text("Continue")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .padding(.horizontal)
                    }
                }
                
                Spacer(minLength: 40)
            }
        }
    }
    
    private func handleLogin() {
        guard !userName.isEmpty else {
            error = "Please enter your name"
            return
        }
        
        let db = Firestore.firestore()
        
        guard let userId = userData["id"] as? String else {
            error = "No user ID"
            return
        }
        
        let newData: [_: Any] = [
            "name": userName,
            "joined": Timestamp(),
            "gymStatus": GymStatus.notInGym.rawValue,
            "statusMessage": ""
        ]
        db.collection("users").document(userId).setData(newData, merge: true) { error in
            if let error = error {
                print("Error updating status: \(error)")
            } else {
                DispatchQueue.main.async {
                    userData.merge(newData) { $1 }
                }
            }
        }
    }
}


