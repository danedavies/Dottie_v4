import SwiftUI
import CoreData

struct GlucoseTrackingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GlucuseEntry.timestamp, ascending: false)],
        animation: .default)
    private var glucoseEntries: FetchedResults<GlucuseEntry>
    
    @State private var showingEntryForm = false
    
    var body: some View {
        NavigationView {
            VStack {
                if glucoseEntries.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue.opacity(0.6))
                        Text("No Glucose Entries Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Tap the + button to add your first entry")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(glucoseEntries) { entry in
                            GlucoseEntryRow(entry: entry)
                        }
                        .onDelete(perform: deleteEntries)
                    }
                }
            }
            .navigationTitle("Glucose Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingEntryForm = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingEntryForm) {
                GlucoseEntryForm()
            }
        }
    }
    
    private func deleteEntries(offsets: IndexSet) {
        withAnimation {
            offsets.map { glucoseEntries[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print("Error deleting: \(error.localizedDescription)")
            }
        }
    }
}

struct GlucoseEntryRow: View {
    let entry: GlucuseEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(Int(entry.glucoseLevel))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(glucoseColor(for: entry.glucoseLevel))
                
                Text("mg/dL")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let source = entry.source {
                    Text(source)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            if let timestamp = entry.timestamp {
                Text(timestamp, style: .date)
                    .font(.caption)
                Text(timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func glucoseColor(for level: Double) -> Color {
        if level < 70 {
            return .red
        } else if level > 180 {
            return .orange
        } else {
            return .green
        }
    }
}

struct GlucoseTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        GlucoseTrackingView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

