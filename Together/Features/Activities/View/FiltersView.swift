//
//  FiltersView.swift
//  Together
//
//  Created by Samara Lima da Silva on 17/02/2026.
//

import SwiftUI

// MARK: - Filter Model

struct FilterState {
    var priceRange: String? = nil
    var duration: String? = nil
    var location: String? = nil

    var totalSelected: Int {
        [priceRange, duration, location].compactMap { $0 }.count
    }
}

// MARK: - FiltersView

struct FiltersView: View {
    @Binding var filterState: FilterState
    @Environment(\.dismiss) private var dismiss

    private let priceOptions = ["LOW", "MEDIUM", "HIGH"]
    private let durationOptions = ["< 2 HOURS", "< 5 HOURS", "1 DAY", "WEEKEND"]
    private let locationOptions = ["INDOORS", "OUTDOORS"]

    var body: some View {
        NavigationStack{
        ZStack{
            Color(.white)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {

                Divider()

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {

                        FilterSection(
                            title: "Price Range",
                            options: priceOptions,
                            selected: filterState.priceRange,
                            color: Color(.verde)
                        ) { option in
                            select(&filterState.priceRange, option)
                        }

                        Divider().padding(.horizontal, 20)

                        FilterSection(
                            title: "Approximate Duration",
                            options: durationOptions,
                            selected: filterState.duration,
                            color: Color(.rosa)
                        ) { option in
                            select(&filterState.duration, option)
                        }

                        Divider().padding(.horizontal, 20)

                        FilterSection(
                            title: "Location",
                            options: locationOptions,
                            selected: filterState.location,
                            color: Color(.lilas)
                        ) { option in
                            select(&filterState.location, option)
                        }
                    }
                }

                Spacer()

                // Apply Button
                Button("Apply filters"){
                    dismiss()
                }
                .modifier(AccentButtonModifier())
                .padding(.horizontal, 20)
                .padding(.bottom, 36)
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button("Clear All") {filterState = FilterState()}
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}

    // Each section only supports a single active value server-side, so
    // tapping a chip either selects it or, if already selected, clears it.
    private func select(_ current: inout String?, _ value: String) {
        current = (current == value) ? nil : value
    }

    struct FilterSection: View{
        let title: String
        let options: [String]
        let selected: String?
        let color: Color
        let onTap:(String) -> Void

        private let columns = [
            GridItem(.flexible(),alignment: .leading),
            GridItem(.flexible(),alignment: .leading),
            GridItem(.flexible(),alignment: .leading),
        ]
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(options, id: \.self) { option in
                        let isSelected = selected == option
                        Button {
                            onTap(option)
                        } label: {
                            Text(option)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.branco)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(isSelected ? color : color.opacity(0.76))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .padding(20)
        }
    }

}

#Preview {
    @Previewable @State var filterState = FilterState()
    return FiltersView(filterState: $filterState)
}
