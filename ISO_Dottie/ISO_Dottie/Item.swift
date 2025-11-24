//
//  Item.swift
//  ISO_Dottie
//
//  Created by Dane Davies on 11/5/25.
//

import SwiftData
import Foundation

@Model
class SleepItem {
    var date: Date
    var hours: Double
    var quality: Double // 0–1 rating or derived from HK
    
    init(date: Date, hours: Double, quality: Double) {
        self.date = date
        self.hours = hours
        self.quality = quality
    }
}

@Model
class ExerciseItem {
    var date: Date
    var steps: Int
    var caloriesBurned: Double
    var duration: Double // minutes
    
    init(date: Date, steps: Int, caloriesBurned: Double, duration: Double) {
        self.date = date
        self.steps = steps
        self.caloriesBurned = caloriesBurned
        self.duration = duration
    }
}

@Model
class NutritionItem {
    var date: Date
    var calories: Double
    var carbs: Double
    var protein: Double
    var fat: Double
    
    init(date: Date, calories: Double, carbs: Double, protein: Double, fat: Double) {
        self.date = date
        self.calories = calories
        self.carbs = carbs
        self.protein = protein
        self.fat = fat
    }
}

@Model
class GlucoseItem {
    var date: Date
    var glucoseLevel: Double // mg/dL
    
    init(date: Date, glucoseLevel: Double) {
        self.date = date
        self.glucoseLevel = glucoseLevel
    }
}
