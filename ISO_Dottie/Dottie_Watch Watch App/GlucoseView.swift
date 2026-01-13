//
//  GlucoseView.swift
//  ISO_Dottie
//
//  Created by Dane Davies on 1/12/26.
//

import SwiftUI
import Observation

struct GlucoseView: View {
    @State private var manager = HealthKitManager()
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Glucose")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let glucose = manager.glucoseLevel {
                Text("\(Int(glucose))")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(glucoseColor(for: glucose))
                
                Text("mg/dL")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "drop.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                
                Text("No Data")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .task {
            await manager.fetchAllData()
            
            // Log glucose reading to Firebase if available
            /*if let glucose = manager.glucoseLevel {
                await FirebaseManager.shared.logGlucoseReading(level: glucose)
            }*/
        }
    }
    
    private func glucoseColor(for level: Double) -> Color {
        switch level {
        case ..<70: return .red
        case 70..<140: return .green
        default: return .orange
        }
    }
}

#Preview {
    GlucoseView()
}
