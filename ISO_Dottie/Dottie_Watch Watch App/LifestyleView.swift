//
//  LifestyleView.swift
//  ISO_Dottie
//
//  Created by Dane Davies on 1/12/26.
//

import SwiftUI
import SwiftData

struct LifestyleView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \LifestyleEntry.timestamp, order: .reverse) private var entries: [LifestyleEntry]
    @State private var selectedCategory = "Exercise"
    
    let lifestyleOptions = [
        LifestyleOption(name: "Swim", icon: "🏊‍♀️", category: "Exercise"),
        LifestyleOption(name: "Run", icon: "🏃‍♀️", category: "Exercise"),
        LifestyleOption(name: "Yoga", icon: "🧘‍♀️", category: "Exercise"),
        LifestyleOption(name: "Walk", icon: "🚶‍♀️", category: "Exercise"),
        LifestyleOption(name: "Bike", icon: "🚴‍♀️", category: "Exercise"),
        LifestyleOption(name: "Gym", icon: "🏋️‍♀️", category: "Exercise"),
        LifestyleOption(name: "Meditate", icon: "🧘", category: "Wellness"),
        LifestyleOption(name: "Good Sleep", icon: "😴", category: "Wellness"),
        LifestyleOption(name: "Stressed", icon: "😰", category: "Wellness"),
        LifestyleOption(name: "Relaxed", icon: "😌", category: "Wellness"),
        LifestyleOption(name: "Happy", icon: "😊", category: "Wellness"),
        LifestyleOption(name: "Alcohol", icon: "🍷", category: "Other"),
        LifestyleOption(name: "Medicine", icon: "💊", category: "Other")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Picker("Category", selection: $selectedCategory) {
                    Text("Exercise").tag("Exercise")
                    Text("Wellness").tag("Wellness")
                    Text("Other").tag("Other")
                }
                
                Section {
                    ForEach(lifestyleOptions.filter { $0.category == selectedCategory }) { option in
                        Button {
                            addLifestyleEntry(option)
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
            .navigationTitle("Lifestyle")
        }
    }
    
    private func addLifestyleEntry(_ option: LifestyleOption) {
        let entry = LifestyleEntry(name: option.name, icon: option.icon, category: option.category)
        context.insert(entry)
        
        // Log to Firebase
        /*
        Task {
            await FirebaseManager.shared.logLifestyleEntry(entry)
        }*/
    }
}

struct LifestyleOption: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let category: String
}

#Preview {
    LifestyleView()
        .modelContainer(for: LifestyleEntry.self, inMemory: true)
}
