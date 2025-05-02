//import SwiftUI
//import Firebase
//import FirebaseAuth
//
////This view is shown during a user's login
//struct SetupNameView: View {
//    @State private var name = ""
//    let db = Firestore.firestore()
//    var onComplete: () -> Void
//
//    var body: some View {
//        VStack(spacing: 20) {
//            //UI for login
//            Text("What's your name?")
//                .font(.largeTitle)
//                .bold()
//
//            TextField("Enter your name", text: $name)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            //Saves the user's name and phone number to Firestore
//            Button("Continue") {
//                guard let userID = Auth.auth().currentUser?.uid else { return }
//                db.collection("users").document(userID).setData([
//                    "name": name,
//                    "phone": Auth.auth().currentUser?.phoneNumber ?? ""
//                ], merge: true) { error in
//                    if error == nil {
//                        onComplete()
//                    } else {
//                        print("Error saving name: \(error!.localizedDescription)")
//                    }
//                }
//            }
//            .padding()
//            .background(Color.pink)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//        }
//        .padding()
//    }
//}
//
