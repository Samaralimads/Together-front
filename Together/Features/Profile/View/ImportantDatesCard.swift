//
//  ImportantDatesCard.swift
//  Together
//
//  Created by Samara Lima da Silva on 16/02/2026.
//
import SwiftUI

struct ImportantDatesCard: View {
    let anniversary: Date
    @Binding var importantDates: [ImportantDate]
    let onAddDate: () -> Void
    @State private var dateToEdit: ImportantDate?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Important Dates")
                    .font(.custom("IvyJournal-Bold", size: 24))
                
                Spacer()
                
                Button {
                    onAddDate()
                } label: {
                    Image(systemName: "calendar.badge.plus")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
            }
            
            List {
                
                DateRowView(
                    title: "Anniversary",
                    date: anniversary,
                    showsChevron: false
                )
                .listRowBackground(Color.clear)
                
                
                ForEach(importantDates) { date in
                    DateRowView(
                        title: date.label,
                        date: date.date,
                        showsChevron: true
                    )
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        
                        Button(role: .destructive) {
                            deleteDate(date)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            editDate(date)
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.accent)
                    }
                }
            }
            .listStyle(.plain)
            .frame(height: CGFloat(min(importantDates.count + 1, 5)) * 70)
            .scrollDisabled(importantDates.count + 1 <= 5)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.branco)
        )
        .sheet(item: $dateToEdit) { date in
            EditImportantDateSheet(
                importantDates: $importantDates,
                dateToEdit: date
            )
        }
    }
    
   private func deleteDate(_ date: ImportantDate) {
        importantDates.removeAll { $0.id == date.id }
    }
    
   private func editDate(_ date: ImportantDate) {
        dateToEdit = date
    }
}

struct DateRowView: View {
    let title: String
    let date: Date
    let showsChevron: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                
                Text(date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if showsChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.3))
            }
        }
    }
}

// MARK: - Add Important Date Sheet
struct AddImportantDateSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var importantDates: [ImportantDate]
    @State private var label = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $label)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Important Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let newDate = ImportantDate(id: UUID(), label: label, date: date)
                        importantDates.append(newDate)
                        dismiss()
                    }
                    .disabled(label.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Edit Important Date Sheet
struct EditImportantDateSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var importantDates: [ImportantDate]
    let dateToEdit: ImportantDate
    
    @State private var label: String
    @State private var date: Date
    
    init(importantDates: Binding<[ImportantDate]>, dateToEdit: ImportantDate) {
        self._importantDates = importantDates
        self.dateToEdit = dateToEdit
        self._label = State(initialValue: dateToEdit.label)
        self._date = State(initialValue: dateToEdit.date)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $label)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Edit Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let index = importantDates.firstIndex(where: { $0.id == dateToEdit.id }) {
                            importantDates[index].label = label
                            importantDates[index].date = date
                        }
                        dismiss()
                    }
                    .disabled(label.isEmpty)
                }
            }
        }
        .tint(.accent)
        .presentationDetents([.medium])
    }
}

#Preview {
    @Previewable @State var anniversary = Date()
    @Previewable @State var importantDates: [ImportantDate] = []
    @Previewable @State var showAddDate = false
    
    Background{
        ImportantDatesCard(
            anniversary: anniversary,
            importantDates: $importantDates,
            onAddDate: {
                showAddDate = true
            }
        ).sheet(isPresented: $showAddDate) {
            AddImportantDateSheet(importantDates: $importantDates)}
        .padding(20)
    }
}
