//
//  PersonalPage.swift
//  momo
//
//  Created by Nadezhda Dominguez Salinas on 3/7/25.
//


import SwiftUI

struct PersonalPage: View {
    @Environment(\.dismiss) var dismiss  // Allows dismissing the screen
//    @State private var email: String = ""
//    @State private var password: String = ""

    var body: some View {
        VStack {
            Text("My Page")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)

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

            Button(action: {}) {
                Text("At Gym")
                    .padding()
                    .foregroundColor(.white)
                    .background(.green)
                    .cornerRadius(100)
            }
            .padding(.horizontal)

            Spacer()
            Button(action: {}) {
                Text("Going to Gym")
                    .padding()
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(100)
            }
            .padding(.horizontal)

            Spacer()
            Button(action: {}) {
                Text("No Gym")
                    .padding()
                    .foregroundColor(.white)
                    .background(.red)
                    .cornerRadius(100)
            }
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
            .padding(.horizontal)

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

