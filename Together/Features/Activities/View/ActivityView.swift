//
//  ActivityView.swift
//  Together
//
//  Created by Samara Lima da Silva on 17/02/2026.
//

import SwiftUI

struct ActivityView: View {
    @State private var selectedCategoryId: UUID? = nil
    @State private var showFilters = false
    @State private var filterState = FilterState()
    
    private var filteredActivities: [Activity] {
        if let selectedCategoryId {
            return mockActivities.filter { $0.categoryId == selectedCategoryId }
        }
        return mockActivities
    }
    
    var body: some View {

            Background{
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        searchBar
                        
                        categoriesRow
                        
                        ListOfActivities
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    .padding(.bottom, 40)
                }
            }
        }
    }

   // MARK: - Components

   private extension ActivityView {
       
       var searchBar: some View {
           HStack(spacing: 12) {
               
               HStack {
                   Text("Search an activity")
                       .foregroundColor(.gray)
                   
                   Spacer()
                   
                   Image(systemName: "magnifyingglass")
                       .foregroundColor(.black.opacity(0.6))
               }
               .padding()
               .background(.white)
               .clipShape(Capsule())
               
               Button {
                   showFilters = true
               } label: {
                   ZStack(alignment: .topTrailing) {
                       Image(systemName: "slider.horizontal.3")
                           .foregroundColor(.black.opacity(0.6))
                           .padding()
                           .background(Color.white)
                           .clipShape(Capsule())
                       
                       if filterState.totalSelected > 0 {
                           Text("\(filterState.totalSelected)")
                               .font(.caption2)
                               .fontWeight(.bold)
                               .foregroundColor(.white)
                               .frame(width: 20, height: 20)
                               .background(Color(.accent))
                               .clipShape(Circle())
                               .offset(x: 4, y: -3)
                       }
                   }
               }
               .fullScreenCover(isPresented: $showFilters) {
                   FiltersView(filterState: $filterState)
               }
           }
           
       }
       var categoriesRow: some View {
           ScrollView(.horizontal, showsIndicators: false) {
               HStack(spacing: 16) {
                   
                   categoryChip(
                       title: "All",
                       isSelected: selectedCategoryId == nil,
                       imageName: "sparkles"
                   ) {
                       selectedCategoryId = nil
                   }
                   
                   ForEach(mockCategories) { category in
                       categoryChip(
                           title: category.name,
                           isSelected: selectedCategoryId == category.id,
                           imageName: category.imageName
                       ) {
                           selectedCategoryId = category.id
                       }
                   }
               }
           }
       }
       
       func categoryChip(title: String, isSelected: Bool, imageName: String, action: @escaping () -> Void) -> some View {
           Button(action: action) {
               VStack(spacing: 6) {
                   
                   ZStack {
                       RoundedRectangle(cornerRadius: 18)
                           .fill(isSelected ? Color.white : Color.white.opacity(0.25))
                           .frame(width: 80, height: 70)
                       
                       Image(imageName)
                           .resizable()
                           .scaledToFit()
                           .frame(width: 40, height: 40)
                   }
                   
                   Text(title)
                       .font(.caption)
                       .foregroundColor(.white)
                       .fontWeight(isSelected ? .bold : .medium)
               }
           }
       }

       
       var ListOfActivities: some View {
           VStack(alignment: .leading, spacing: 16) {
               ForEach(filteredActivities) { activity in
                   if let category = mockCategories.first(where: { $0.id == activity.categoryId }) {
                       NavigationLink(destination: ActivityDetailView(activity: activity, category: category)) {
                           ActivityCard(activity: activity, category: category)
                       }
                   }
               }
           }
       }
   }


#Preview {

    ActivityView()
}
