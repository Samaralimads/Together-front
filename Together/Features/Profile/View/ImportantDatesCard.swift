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
    let onDelete: (ImportantDate) -> Void
    let onEdit: (ImportantDate) -> Void
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
                DateRowView(title: "Anniversary", date: anniversary, showsChevron: false)
                    .listRowBackground(Color.clear)

                ForEach(importantDates) { date in
                    DateRowView(title: date.label, date: date.date, showsChevron: true)
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                onDelete(date)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            Button {
                                dateToEdit = date
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
        .background(RoundedRectangle(cornerRadius: 25).fill(.branco))
        .sheet(item: $dateToEdit) { date in
            EditImportantDateSheet(date: date) { updated in
                onEdit(updated)
            }
        }
    }
}

// MARK: - Date Row
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

// MARK: - Add Sheet
struct AddImportantDateSheet: View {
    @Environment(\.dismiss) var dismiss
    let onAdd: (String, Date) -> Void
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
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(label, date)
                        dismiss()
                    }
                    .disabled(label.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Edit Sheet
struct EditImportantDateSheet: View {
    @Environment(\.dismiss) var dismiss
    let date: ImportantDate
    let onSave: (ImportantDate) -> Void
    @State private var label: String
    @State private var selectedDate: Date

    init(date: ImportantDate, onSave: @escaping (ImportantDate) -> Void) {
        self.date = date
        self.onSave = onSave
        self._label = State(initialValue: date.label)
        self._selectedDate = State(initialValue: date.date)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $label)
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Edit Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var updated = date
                        updated.label = label
                        updated.date = selectedDate
                        onSave(updated)
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
    @Previewable @State var importantDates: [ImportantDate] = []

    Background {
        ImportantDatesCard(
            anniversary: Date(),
            importantDates: $importantDates,
            onAddDate: {},
            onDelete: { _ in },
            onEdit: { _ in }
        )
        .padding(20)
    }
}
