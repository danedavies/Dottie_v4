import SwiftUI
import CoreData

struct GlucoseEntryForm: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var glucoseLevel: String = ""
    @State private var insulinDose: String = ""
    @State private var carbs: String = ""
    @State private var exercise: String = ""
    @State private var notes: String = ""
    @State private var selectedSource: String = "Manual"
    @State private var timestamp: Date = Date()
    @State private var showingSuccessAlert = false
    
    let sources = ["Manual", "CGM", "Fingerstick", "Other"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Glucose Reading")) {
                    HStack {
                        TextField("mg/dL", text: $glucoseLevel)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                        Text("mg/dL")
                            .foregroundColor(.secondary)
                    }
                    
                    Picker("Source", selection: $selectedSource) {
                        ForEach(sources, id: \.self) { source in
                            Text(source).tag(source)
                        }
                    }
                    
                    DatePicker("Time", selection: $timestamp, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("Related Factors")) {
                    HStack {
                        TextField("Units", text: $insulinDose)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                        Text("Insulin (units)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        TextField("grams", text: $carbs)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                        Text("Carbs (g)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        TextField("minutes", text: $exercise)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                        Text("Exercise (min)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
                
                Section {
                    Button(action: saveEntry) {
                        HStack {
                            Spacer()
                            Text("Save Entry")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(glucoseLevel.isEmpty)
                }
            }
            .navigationTitle("New Glucose Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Entry Saved", isPresented: $showingSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your glucose entry has been saved successfully.")
            }
        }
    }
    
    private func saveEntry() {
        guard let glucoseValue = Double(glucoseLevel), glucoseValue > 0 else {
            return
        }
        
        // Save to GlucuseEntry entity
        let glucoseEntry = GlucuseEntry(context: viewContext)
        glucoseEntry.glucoseLevel = glucoseValue
        glucoseEntry.source = selectedSource
        glucoseEntry.timestamp = timestamp
        
        // Save insulin as BioFactor if provided
        if let insulinValue = Double(insulinDose), insulinValue > 0 {
            let insulinFactor = BioFactor(context: viewContext)
            insulinFactor.type = "Insulin"
            insulinFactor.value = insulinValue
            insulinFactor.timestamp = timestamp
        }
        
        // Save carbs as BioFactor if provided
        if let carbsValue = Double(carbs), carbsValue > 0 {
            let carbsFactor = BioFactor(context: viewContext)
            carbsFactor.type = "Carbs"
            carbsFactor.value = carbsValue
            carbsFactor.timestamp = timestamp
        }
        
        // Save exercise as BioFactor if provided
        if let exerciseValue = Double(exercise), exerciseValue > 0 {
            let exerciseFactor = BioFactor(context: viewContext)
            exerciseFactor.type = "Exercise"
            exerciseFactor.value = exerciseValue
            exerciseFactor.timestamp = timestamp
        }
        
        // Save notes as BioFactor if provided
        if !notes.isEmpty {
            // For notes, we could store them differently or use a separate field
            // For now, we'll store the length or create a note entry
            let noteFactor = BioFactor(context: viewContext)
            noteFactor.type = "Notes"
            noteFactor.value = Double(notes.count) // Store character count, or you could extend the model
            noteFactor.timestamp = timestamp
        }
        
        do {
            try viewContext.save()
            showingSuccessAlert = true
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
}

struct GlucoseEntryForm_Previews: PreviewProvider {
    static var previews: some View {
        GlucoseEntryForm()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

