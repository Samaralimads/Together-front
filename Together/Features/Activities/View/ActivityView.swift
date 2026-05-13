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
    @State private var searchText: String = ""

    
    private var filteredActivities: [Activity] {
        mockActivities.filter { activity in
            
            let matchesCategory =
                selectedCategoryId == nil ||
                activity.categoryId == selectedCategoryId
            
            let matchesSearch =
                searchText.isEmpty ||
                activity.title.localizedCaseInsensitiveContains(searchText)
            
            return matchesCategory && matchesSearch
        }
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
                          Image(systemName: "magnifyingglass")
                              .foregroundColor(.black.opacity(0.6))
                          
                          TextField("Search an activity", text: $searchText)
                              .textFieldStyle(.plain)
                              .foregroundColor(.black)
                          
                          if !searchText.isEmpty {
                              Button {
                                  searchText = ""
                              } label: {
                                  Image(systemName: "xmark.circle.fill")
                                      .foregroundColor(.gray)
                              }
                          }
                      }
                      .padding()
                      .background(.white)
                      .clipShape(Capsule())
               
               //filters
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
                       imageName: "Sparkles"
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
           LazyVStack(alignment: .leading, spacing: 16) {
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
