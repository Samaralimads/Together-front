//
//  FiltersView.swift
//  Together
//
//  Created by Samara Lima da Silva on 17/02/2026.
//

import SwiftUI

// MARK: - Filter Model

struct FilterState {
    var priceRange: Set<String> = []
    var duration: Set<String> = []
    var location: Set<String> = []
    
    var totalSelected: Int {
        priceRange.count + duration.count + location.count
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
        VStack(spacing: 0) {
            // Header
            ZStack {
                HStack {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.black)
                    Spacer()
                    Button("Clear All") {
                        filterState = FilterState()
                    }
                    .foregroundColor(.black)
                }
                Text("Filter")
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    filterSection(
                        title: "Price Range",
                        badge: filterState.priceRange.count,
                        options: priceOptions,
                        selected: filterState.priceRange,
                        color: Color(.verde)
                    ) { option in
                        toggle(&filterState.priceRange, option)
                    }
                    
                    Divider().padding(.horizontal, 20)
                    
                    filterSection(
                        title: "Approximate Duration",
                        badge: filterState.duration.count,
                        options: durationOptions,
                        selected: filterState.duration,
                        color: Color(.rosa)
                    ) { option in
                        toggle(&filterState.duration, option)
                    }
                    
                    Divider().padding(.horizontal, 20)
                    
                    filterSection(
                        title: "Location",
                        badge: filterState.location.count,
                        options: locationOptions,
                        selected: filterState.location,
                        color: Color(.lilas)
                    ) { option in
                        toggle(&filterState.location, option)
                    }
                }
            }
            
            Spacer()
            
            // Apply Button
            AccentButton(title: "Apply filters"){
                dismiss()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 36)
        }
        .background(Color.white)
    }
    
    private func toggle(_ set: inout Set<String>, _ value: String) {
        if set.contains(value) { set.remove(value) } else { set.insert(value) }
    }
    
    @ViewBuilder
    private func filterSection(
        title: String,
        badge: Int,
        options: [String],
        selected: Set<String>,
        color: Color,
        onTap: @escaping (String) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                if badge > 0 {
                    Text("\(badge)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 22, height: 22)
                        .background(color)
                        .clipShape(Circle())
                }
            }
            
            FlowLayout(spacing: 10) {
                ForEach(options, id: \.self) { option in
                    let isSelected = selected.contains(option)
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

// MARK: - Simple Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let height = rows.map { $0.map { subviews[$0].sizeThatFits(.unspecified).height }.max() ?? 0 }
            .reduce(0) { $0 + $1 + spacing } - spacing
        return CGSize(width: proposal.width ?? 0, height: max(height, 0))
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        for row in rows {
            let rowHeight = row.map { subviews[$0].sizeThatFits(.unspecified).height }.max() ?? 0
            var x = bounds.minX
            for index in row {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += rowHeight + spacing
        }
    }
    
    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[Int]] {
        let maxWidth = proposal.width ?? .infinity
        var rows: [[Int]] = [[]]
        var currentRowWidth: CGFloat = 0
        for (i, subview) in subviews.enumerated() {
            let width = subview.sizeThatFits(.unspecified).width
            if currentRowWidth + width > maxWidth && !rows[rows.count - 1].isEmpty {
                rows.append([])
                currentRowWidth = 0
            }
            rows[rows.count - 1].append(i)
            currentRowWidth += width + spacing
        }
        return rows
    }
}

#Preview {
    @Previewable @State var filterState = FilterState()
    return FiltersView(filterState: $filterState)
}
