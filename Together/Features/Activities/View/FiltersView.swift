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
                            badge: filterState.priceRange.count,
                            options: priceOptions,
                            selected: filterState.priceRange,
                            color: Color(.verde)
                        ) { option in
                            toggle(&filterState.priceRange, option)
                        }
                        
                        Divider().padding(.horizontal, 20)
                        
                        FilterSection(
                            title: "Approximate Duration",
                            badge: filterState.duration.count,
                            options: durationOptions,
                            selected: filterState.duration,
                            color: Color(.rosa)
                        ) { option in
                            toggle(&filterState.duration, option)
                        }
                        
                        Divider().padding(.horizontal, 20)
                        
                        FilterSection(
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
    
    private func toggle(_ set: inout Set<String>, _ value: String) {
        if set.contains(value) { set.remove(value) } else { set.insert(value) }
    }
    
    struct FilterSection: View{
        let title: String
        let badge: Int
        let options: [String]
        let selected: Set<String>
        let color: Color
        let onTap:(String) -> Void
        
        private let columns = [
            GridItem(.flexible(),alignment: .leading),
            GridItem(.flexible(),alignment: .leading),
            GridItem(.flexible(),alignment: .leading),
        ]
        var body: some View {
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
                
                LazyVGrid(columns: columns, spacing: 10) {
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
    
}

#Preview {
    @Previewable @State var filterState = FilterState()
    return FiltersView(filterState: $filterState)
}
