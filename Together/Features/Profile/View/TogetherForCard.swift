//
//  TogetherForCard.swift
//  Together
//
//  Created by Samara Lima da Silva on 16/02/2026.
//
import SwiftUI

struct TogetherForCard: View {
    let anniversary: Date
    let onEdit: () -> Void
    
    var timeComponents: (years: Int, months: Int, days: Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: anniversary, to: Date())
        return (components.year ?? 0, components.month ?? 0, components.day ?? 0)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Together for")
                    .font(.custom("IvyJournal-Bold", size: 24))
                Spacer()
                
                Button {
                    onEdit()
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 22))
                        .foregroundColor(.accent)
                }
            }
            
            HStack(spacing: 30) {
                TimeUnitView(value: String(format: "%02d", timeComponents.years), label: "Years")
                TimeUnitView(value: String(format: "%02d", timeComponents.months), label: "Months")
                TimeUnitView(value: String(format: "%02d", timeComponents.days), label: "Days")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.accent)
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.branco)
        )
    }
}

struct TimeUnitView: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack() {
            Text(value)
                .font(.custom("IvyJournal-Bold", size: 35))
            Text(label)
                .font(.system(size: 11))
        }
        .foregroundColor(.branco)

    }
}

// MARK: - Edit Anniversary Sheet
struct EditAnniversarySheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var anniversary: Date
    @State private var tempDate: Date
    
    init(anniversary: Binding<Date>) {
        self._anniversary = anniversary
        self._tempDate = State(initialValue: anniversary.wrappedValue)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                DatePicker("Anniversary Date", selection: $tempDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Edit Anniversary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        anniversary = tempDate
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}


