//
//  HormoneView.swift
//  ISO_Dottie
//
//  Created by Dane Davies on 1/12/26.
//

import SwiftUI
import SwiftData

struct HormoneView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \HormoneEntry.timestamp, order: .reverse) private var entries: [HormoneEntry]
    @State private var selectedType = "cycle"
    
    let hormoneOptions = [
        HormoneOption(name: "Start Period", icon: "🔴", type: "cycle"),
        HormoneOption(name: "End Period", icon: "⚪️", type: "cycle"),
        HormoneOption(name: "Ovulation", icon: "🥚", type: "cycle"),
        HormoneOption(name: "PMS", icon: "😣", type: "symptom"),
        HormoneOption(name: "Cramps", icon: "💢", type: "symptom"),
        HormoneOption(name: "Mood Swings", icon: "😤", type: "symptom"),
        HormoneOption(name: "Fatigue", icon: "😴", type: "symptom"),
        HormoneOption(name: "Bloating", icon: "🎈", type: "symptom"),
        HormoneOption(name: "Headache", icon: "🤕", type: "symptom")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Picker("Type", selection: $selectedType) {
                    Text("Cycle").tag("cycle")
                    Text("Symptoms").tag("symptom")
                }
                
                Section {
                    ForEach(hormoneOptions.filter { $0.type == selectedType }) { option in
                        Button {
                            addHormoneEntry(option)
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
                                    Text(entry.timestamp, style: .date)
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
            .navigationTitle("Hormone")
        }
    }
    
    private func addHormoneEntry(_ option: HormoneOption) {
        let entry = HormoneEntry(name: option.name, icon: option.icon, type: option.type)
        context.insert(entry)
        
     // Location of DB
    }
}

struct HormoneOption: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let type: String
}

#Preview {
    HormoneView()
        .modelContainer(for: HormoneEntry.self, inMemory: true)
}
