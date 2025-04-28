//
//  LoadingView.swift
//  momo
//
//  Created by William Acosta on 4/9/25.
//

import SwiftUI

//Displays a loading page while awaiting user authentification or data fetching
struct LoadingView: View {
    @AppStorage("userId") private var userId: String?

    var body: some View {
        VStack {
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}
