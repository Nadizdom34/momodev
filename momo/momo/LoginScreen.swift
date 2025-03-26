//
//  LoginScreen.swift
//  momo
//
//  Created by William Acosta on 3/7/25.
//


import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import FirebaseAnalytics


struct LoginScreen: View {
    @Environment(\.dismiss) var dismiss  // Allows dismissing the screen
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Text("Log In")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            // Email Field
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            // Password Field
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Login Button
            Button(action: {
                handleLogin()
            }) {
                Text("Log In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
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

    private func handleLogin() {
        // Handle login logic here (e.g., validate credentials)
        print("Logging in with \(email) and \(password)")
    }
}
