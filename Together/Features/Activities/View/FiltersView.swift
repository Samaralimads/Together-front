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
            Color.cardFill
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {

                Rectangle()
                    .fill(Color.rowDivider)
                    .frame(height: 1)

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {

                        FilterSection(
                            title: "Price Range",
                            options: priceOptions,
                            selected: filterState.priceRange
                        ) { option in
                            select(&filterState.priceRange, option)
                        }

                        Rectangle().fill(Color.rowDivider).frame(height: 1).padding(.horizontal, 20)

                        FilterSection(
                            title: "Approximate Duration",
                            options: durationOptions,
                            selected: filterState.duration
                        ) { option in
                            select(&filterState.duration, option)
                        }

                        Rectangle().fill(Color.rowDivider).frame(height: 1).padding(.horizontal, 20)

                        FilterSection(
                            title: "Location",
                            options: locationOptions,
                            selected: filterState.location
                        ) { option in
                            select(&filterState.location, option)
                        }
                    }
                }

                Spacer()

                HStack(spacing: Spacing.m) {
                    Button("Clear All") {
                        filterState = FilterState()
                    }
                    .buttonStyle(.luckySecondary)

                    // Apply Button
                    Button("Apply filters"){
                        dismiss()
                    }
                    .buttonStyle(.luckyPrimary)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancel") { dismiss() }
                        .font(.luckyBodyStrong)
                        .foregroundStyle(Color.luckyBlue)
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
        let onTap:(String) -> Void

        private let columns = [
            GridItem(.adaptive(minimum: 90), spacing: 10, alignment: .leading)
        ]
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.luckyHeadline)
                    .foregroundStyle(Color.charcoal)

                LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                    ForEach(options, id: \.self) { option in
                        let isSelected = selected == option
                        Button {
                            onTap(option)
                        } label: {
                            Text(option)
                                .font(.luckyCaptionStrong)
                                .foregroundStyle(isSelected ? Color.cardFill : Color.charcoal)
                                .padding(.horizontal, 16)
                                .frame(height: 40)
                                .luckyOutline(
                                    Capsule(),
                                    fill: isSelected ? Color.luckyBlueLight : Color.cardFill,
                                    shadowOffset: isSelected ? 3 : 0
                                )
                        }
                        .buttonStyle(.plain)
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
