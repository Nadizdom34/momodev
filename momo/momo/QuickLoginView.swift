//
//  QuickLoginView.swift
//  momo
//
//  Created by William Acosta on 4/8/25.
//


import SwiftUI
import FirebaseFirestore

struct QuickLoginView: View {
    @State private var phoneNumber = ""
    @State private var userName = ""
    @State private var showNameField = false
    @State private var error: String?
    
    var onLoginSuccess: (_ userData: [String: Any]) -> Void

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter phone number", text: $phoneNumber)
                .keyboardType(.phonePad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if showNameField {
                TextField("Enter your name", text: $userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            if let error = error {
                Text(error)
                    .foregroundColor(.red)
            }

            Button(showNameField ? "Create Account" : "Continue") {
                let formattedPhone = phoneNumber.hasPrefix("+") ? phoneNumber : "+1" + phoneNumber
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(formattedPhone)

                userRef.getDocument { docSnapshot, err in
                    if let err = err {
                        error = "Error checking user: \(err.localizedDescription)"
                        return
                    }

                    if let data = docSnapshot?.data() {
                        // ✅ User exists — log them in
                        onLoginSuccess(data)
                    } else if showNameField {
                        // 🆕 Create new user
                        let newUser = [
                            "name": userName,
                            "phone": formattedPhone,
                            "joined": Timestamp()
                        ] as [String : Any]

                        userRef.setData(newUser) { error in
                            if let error = error {
                                self.error = "Failed to create user: \(error.localizedDescription)"
                            } else {
                                onLoginSuccess(newUser)
                            }
                        }
                    } else {
                        // 🕵️ No user yet — ask for name
                        withAnimation {
                            showNameField = true
                        }
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}
