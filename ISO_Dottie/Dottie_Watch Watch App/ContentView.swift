//
//  ContentView.swift
//  Dottie_Watch Watch App
//
//  Created by Dane Davies on 11/18/25.
//

import SwiftData
import SwiftUI
import Foundation
import Combine

struct ContentView: View {
    @StateObject private var vm = DashboardViewModel()
    
       
       var body: some View {
           VStack {
               // Top title
               Text("Dottie")
                   .font(.largeTitle)
                   .fontWeight(.bold)
                   .padding(.top)
               
               Spacer()
               
               // Glucose reading in the middle
               if let glucose = vm.manager.glucoseLevel {
                   Text("\(Int(glucose)) mg/dL")
                       .font(.system(size: 40, weight: .semibold))
                       .padding()
                       .background(Circle().fill(Color.blue.opacity(0.1)))
               } else {
                   Text("No Glucose Data")
                       .font(.headline)
                       .foregroundColor(.gray)
               }
               
               Spacer()
               
               // Three-column summary
               HStack {
                   VStack {
                       Text("Sleep")
                           .font(.headline)
                       if let hours = vm.manager.sleepHours {
                           Text("\(hours, specifier: "%.1f") h")
                       } else {
                           Text("No Data")
                               .foregroundColor(.gray)
                       }
                   }
                   Spacer()
                   VStack {
                       Text("Exercise")
                           .font(.headline)
                       if let steps = vm.manager.stepCount {
                           Text("\(steps) steps")
                       } else {
                           Text("No Data")
                               .foregroundColor(.gray)
                       }
                   }
                   Spacer()
                   VStack {
                       Text("Calories")
                           .font(.headline)
                       if let kcal = vm.manager.activeCalories {
                           Text("\(Int(kcal)) kcal")
                       } else {
                           Text("No Data")
                               .foregroundColor(.gray)
                       }
                   }
               }
               .padding(.horizontal)
               
               Spacer()
               
               // Bottom insights
               Button(action: { vm.nextInsight() }) {
                   Text(vm.insightText)
                       .font(.headline)
                       .padding()
                       .frame(maxWidth: .infinity)
                       .background(Color.gray.opacity(0.15))
                       .cornerRadius(12)
               }
               .padding(.bottom)
           }
           .padding()
           .task {
               await vm.manager.fetchAllData()
           }
       }
}
