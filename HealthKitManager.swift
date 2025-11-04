

import Foundation
import HealthKit
import SwiftUI

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published var glucoseData: [(Date, Double)] = []

    init() {
        requestAuthorization()
    }

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        let glucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)!
        healthStore.requestAuthorization(toShare: [], read: [glucoseType]) { success, _ in
            if success {
                self.fetchGlucoseData()
            }
        }
    }

    func fetchGlucoseData() {
        let glucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose)!
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) // last 7 days
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date())

        let query = HKSampleQuery(sampleType: glucoseType, predicate: predicate, limit: 100, sortDescriptors: [sort]) { _, results, _ in
            var data: [(Date, Double)] = []
            results?.forEach { sample in
                if let s = sample as? HKQuantitySample {
                    let value = s.quantity.doubleValue(for: .milligramsPerDeciliter)
                    data.append((s.endDate, value))
                }
            }
            DispatchQueue.main.async {
                self.glucoseData = data
            }
        }
        healthStore.execute(query)
    }
}
