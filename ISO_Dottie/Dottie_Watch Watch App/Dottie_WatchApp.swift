//
//  Dottie_WatchApp.swift
//  Dottie_Watch Watch App
//
//  Created by Dane Davies on 11/18/25.
//

import SwiftUI
import SwiftData

@main
struct Dottie_WatchApp: App {
    
   
    
    
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }.modelContainer(for: [
            FoodEntry.self,
            HormoneEntry.self,
            LifestyleEntry.self
        ])
    }
}
