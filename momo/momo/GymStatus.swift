//
//  GymStatus.swift
//  momo
//
//  Created by William Acosta on 4/8/25.
//


import SwiftUI

enum GymStatus: String, CaseIterable {
    case inGym = "At Gym"
    case notInGym = "No Gym"
    case goingToGym = "Going to Gym"

    var color: Color {
        switch self {
        case .inGym: return .green
        case .notInGym: return .red
        case .goingToGym: return .orange
        }
    }
}
