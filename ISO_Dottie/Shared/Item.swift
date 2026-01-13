//
//  Item.swift
//  ISO_Dottie
//
//  Created by Dane Davies on 11/5/25.
//

import SwiftData
import Foundation

// Food Entry Model
@Model
class FoodEntry {
    var id: UUID
    var name: String
    var icon: String
    var category: String
    var timestamp: Date
    
    init(name: String, icon: String, category: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.category = category
        self.timestamp = timestamp
    }
}

// Hormone Entry Model
@Model
class HormoneEntry {
    var id: UUID
    var name: String
    var icon: String
    var type: String
    var timestamp: Date
    
    init(name: String, icon: String, type: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.type = type
        self.timestamp = timestamp
    }
}

// Lifestyle Entry Model
@Model
class LifestyleEntry {
    var id: UUID
    var name: String
    var icon: String
    var category: String
    var timestamp: Date
    
    init(name: String, icon: String, category: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.category = category
        self.timestamp = timestamp
    }
}

// Legacy models (temp) REMOVE AFTER TESTING IF NOT NEEDED
@Model
class SleepItem {
    var date: Date
    var hours: Double
    var quality: Double
    
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
    var duration: Double
    
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
    var glucoseLevel: Double
    
    init(date: Date, glucoseLevel: Double) {
        self.date = date
        self.glucoseLevel = glucoseLevel
    }
}
