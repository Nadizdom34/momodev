//
//  ContentView.swift
//  testproducts
//
//  Created by Karla Martinez on 2/26/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showLoginScreen = false

    var body: some View {
        VStack {
            Spacer()
            
            Text("MOMO DEV")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
        
            
            Spacer()
            
            Circle()
                .fill(Color.pink.opacity(0.3))
                .frame(width:300, height: 300)
                .padding()
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(action: {
                    // Handle login action
                    showLoginScreen=true
                }) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $showLoginScreen) {
                                    LoginView()
                                }
                
                Button(action: {
                    // Handle sign-up action
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct LoginView: View {
    var body: some View {
        VStack {
            Text("Login Screen")
                .font(.largeTitle)
                .padding()
            
            Button("Dismiss") {
                // Dismiss login screen
            }
            .padding()
        }
        
    }
}

#Preview {
    ContentView()
}
