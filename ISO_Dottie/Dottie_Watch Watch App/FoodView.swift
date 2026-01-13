//
//  FoodView.swift
//  ISO_Dottie
//
//  Created by Dane Davies on 1/12/26.
//

import SwiftUI
import SwiftData

struct FoodView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \FoodEntry.timestamp, order: .reverse) private var entries: [FoodEntry]
    @State private var selectedCategory = "Main"
    
    let foodOptions = [
        FoodOption(name: "Pizza", icon: "🍕", category: "Main"),
        FoodOption(name: "Salad", icon: "🥗", category: "Main"),
        FoodOption(name: "Pasta", icon: "🍝", category: "Main"),
        FoodOption(name: "Burger", icon: "🍔", category: "Main"),
        FoodOption(name: "Sushi", icon: "🍣", category: "Main"),
        FoodOption(name: "Apple", icon: "🍎", category: "Snack"),
        FoodOption(name: "Banana", icon: "🍌", category: "Snack"),
        FoodOption(name: "Chips", icon: "🥔", category: "Snack"),
        FoodOption(name: "Yogurt", icon: "🥛", category: "Snack"),
        FoodOption(name: "Coffee", icon: "☕️", category: "Drink"),
        FoodOption(name: "Water", icon: "💧", category: "Drink"),
        FoodOption(name: "Juice", icon: "🧃", category: "Drink")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Picker("Category", selection: $selectedCategory) {
                    Text("Main").tag("Main")
                    Text("Snack").tag("Snack")
                    Text("Drink").tag("Drink")
                }
                
                Section {
                    ForEach(foodOptions.filter { $0.category == selectedCategory }) { option in
                        Button {
                            addFoodEntry(option)
                        } label: {
                            HStack {
                                Text(option.icon)
                                    .font(.title2)
                                Text(option.name)
                                    .font(.body)
                            }
                        }
                    }
                }
                
                if !entries.isEmpty {
                    Section("Recent") {
                        ForEach(entries.prefix(3)) { entry in
                            HStack {
                                Text(entry.icon)
                                VStack(alignment: .leading) {
                                    Text(entry.name)
                                        .font(.caption)
                                    Text(entry.timestamp, style: .time)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    context.delete(entry)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Food")
        }
    }
    
    private func addFoodEntry(_ option: FoodOption) {
        let entry = FoodEntry(name: option.name, icon: option.icon, category: option.category)
        context.insert(entry)
        
        // Log to Firebase
        /*
        Task {
            await FirebaseManager.shared.logFoodEntry(entry)
        }*/
    }
}

struct FoodOption: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let category: String
}

#Preview {
    FoodView()
        .modelContainer(for: FoodEntry.self, inMemory: true)
}
