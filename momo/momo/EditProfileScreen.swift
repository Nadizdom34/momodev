////  ProfileEditScreen.swift
////  momo
//
//import SwiftUI
//
//struct ProfileEditScreen: View {
//    @Environment(\.dismiss) var dismiss
//    @Binding var name: String
//    @Binding var status: GymStatus
//
//    var body: some View {
//        NavigationStack {
//            Form {
//                TextField("Your Name", text: $name)
//
//                
//            }
//            .navigationTitle("Edit Profile")
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Save") {
//                        dismiss()  // Save the changes and return to PersonalPage
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct HomeScreen: View {
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Text("Welcome to MOMO DEV")
//                    .font(.largeTitle)
//                    .padding()
//
//                Text("This is your Home Screen")
//                    .font(.title2)
//                    .padding()
//
//                NavigationLink(destination: PersonalPage()) {
//                    Text("Go to Personal Page")
//                        .padding()
//                        .foregroundColor(.white)
//                        .background(.blue)
//                        .cornerRadius(10)
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ProfileEditScreen(name: .constant("Yeshe"), status: .constant(.inGym))
//}
