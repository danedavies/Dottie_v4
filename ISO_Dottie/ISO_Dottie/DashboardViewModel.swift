//
//  ViewModel.swift
//  ISO_Dottie
//
//  Created by Dane Davies on 11/8/25.
//


import SwiftData
import SwiftUI
import Foundation
import Combine


@MainActor
class DashboardViewModel: ObservableObject {
    @Published var insightIndex = 0
    @Published var manager = HealthKitManager()
    
    var insightText: String {
        switch insightIndex {
        case 0:
            return "Good sleep supports stable glucose levels."
        case 1:
            return "Exercise helps reduce glucose spikes."
        case 2:
            return "Balanced meals promote glucose stability."
        default:
            return "Keep building healthy habits!"
        }
    }
    
    func nextInsight() {
        insightIndex = (insightIndex + 1) % 3
    }
}
