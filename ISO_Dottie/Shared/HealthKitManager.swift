//
//  HealthKitManager.swift
//  ISO_Dottie
//
//  Created by Dane Davies on 11/7/25.
//
import Foundation
import HealthKit
import Combine

@MainActor
class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    
    // Published properties for UI
    @Published var glucoseLevel: Double?
    @Published var sleepHours: Double?
    @Published var stepCount: Int?
    @Published var activeCalories: Double?
    
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw NSError(domain: "HealthKit not available", code: 1)
        }
        
        let glucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose)!
        let activeEnergyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let bodyMassType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let toRead: Set<HKObjectType> = [glucoseType, activeEnergyType, bodyMassType, stepsType, sleepType]
        
        try await healthStore.requestAuthorization(toShare: [], read: toRead)
    }
    
   
    func fetchGlucoseSamples() async throws -> [HKQuantitySample] {
        let glucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose)!
        let predicate = HKQuery.predicateForSamples(withStart: .distantPast, end: Date())
        
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.quantitySample(type: glucoseType, predicate: predicate)],
            sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)]
        )
        
        let results = try await descriptor.result(for: healthStore)
        return results
    }
    
    
    func fetchActiveEnergy() async throws -> Double {
        let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let predicate = HKQuery.predicateForSamples(withStart: .distantPast, end: Date())
        
        let descriptor = HKStatisticsQueryDescriptor(
            predicate: .quantitySample(type: energyType, predicate: predicate),
            options: .cumulativeSum
        )
        
        let result = try await descriptor.result(for: healthStore)
        return result?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0
    }
    
    func fetchWeightSamples() async throws -> [HKQuantitySample] {
        let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        let predicate = HKQuery.predicateForSamples(withStart: .distantPast, end: Date())
        
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.quantitySample(type: weightType, predicate: predicate)],
            sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)]
        )
        
        let results = try await descriptor.result(for: healthStore)
        return results
    }
    
    func fetchAllData() async {
        do {
            let glucoseSamples = try await fetchGlucoseSamples()
            if let latestGlucose = glucoseSamples.first {
                glucoseLevel = latestGlucose.quantity.doubleValue(for: HKUnit(from: "mg/dL"))
            }
            
            activeCalories = try await fetchActiveEnergy()
            
            stepCount = try await fetchSteps()
            
            sleepHours = try await fetchSleep()
            
        } catch {
            print("Error fetching HealthKit data: \(error)")
        }
    }
    
    func fetchSteps() async throws -> Int {
        let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now)
        
        let descriptor = HKStatisticsQueryDescriptor(
            predicate: .quantitySample(type: stepsType, predicate: predicate),
            options: .cumulativeSum
        )
        
        let result = try await descriptor.result(for: healthStore)
        return Int(result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0)
    }
    
    func fetchSleep() async throws -> Double {
        let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now)
        
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.categorySample(type: sleepType, predicate: predicate)],
            sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)]
        )
        
        let results = try await descriptor.result(for: healthStore)
        
        // Calculate total sleep duration in hours
        let totalSeconds = results.reduce(0.0) { total, sample in
            total + sample.endDate.timeIntervalSince(sample.startDate)
        }
        
        return totalSeconds / 3600.0 // Convert to hours
    }
}
