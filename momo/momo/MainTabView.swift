//
//  MainTabView.swift
//  momo
//
//  Created by William Acosta on 4/8/25.
//


import SwiftUI

//Gives the main tab navigation for the app and uses a user's information
struct MainTabView: View {
    var userData: [String: Any]
    @AppStorage("userId") private var userId: String?

    var body: some View {
        TabView {
            PersonalPage(userData: userData)
                .tabItem { Label("My Page", systemImage: "person.crop.circle") }

            FriendsListScreen()
                .tabItem { Label("Friends", systemImage: "person.2.fill") }
        }
    }
}
