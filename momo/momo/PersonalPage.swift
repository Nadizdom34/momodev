//
//  PersonalPage.swift
//  momo
//
//  Created by Nadezhda Dominguez Salinas on 3/7/25.
//


import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import FirebaseAnalytics


struct PersonalPage: View {
    @Environment(\.dismiss) var dismiss  // Allows dismissing the screen
//    @State private var email: String = ""
//    @State private var password: String = ""

    var body: some View {
        VStack {
            Text("My Gym Status")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("Nadiz")
                .font(.headline)
                .padding(.horizontal,-150)
            Text("It's leg day!!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal,-150)

//            // Email Field
//            TextField("Email", text: $email)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//                .keyboardType(.emailAddress)
//                .autocapitalization(.none)
//
//            // Password Field
//            SecureField("Password", text: $password)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
            Circle()
                .fill(Color.purple.opacity(0.3))
                .frame(width: 150, height: 150)
                .padding()
            
            Button(action: {}) {
                Text("At Gym")
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.green)
                    .cornerRadius(30)
            }
//            .padding(.horizontal,100)

//            Spacer().frame(width:2)
            Button(action: {}) {
                Text("Going to Gym")
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(30)

            }
            .padding(.horizontal,100)

            Button(action: {}) {
                Text("No Gym")
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.red)
                    .cornerRadius(30)
            }
            .padding(.horizontal)

            // Login Button
//            Button(action: {
////                handleLogin()
//            }) {
//                Text("At Gym")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
            .padding(.horizontal,30)

            Spacer()

            // Dismiss Button
            Button("Back") {
                dismiss()
            }
            .padding()
        }
        .padding()
    }

//    private func handleLogin() {
//        // Handle login logic here (e.g., validate credentials)
//        print("Logging in with \(email) and \(password)")
//    }
}

