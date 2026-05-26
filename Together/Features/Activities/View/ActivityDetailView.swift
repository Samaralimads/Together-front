//
//  ActivityDetailView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI

struct ActivityDetailView: View {
    let activity: Activity
    let category: Category
    
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var isFavorite = false
    
    var body: some View {
        Background {
            
            // MARK: - Top area (category + title + image)
            VStack(spacing: 60) {
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(category.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text(activity.title)
                            .font(.custom("IvyJournal-Bold", size: 24))
                            .foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    Image(category.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                }
                .padding(.horizontal, 15)
                
                // MARK: - White card
                
                ScrollView{
                    VStack(alignment: .leading, spacing: 24) {
                        
                        InfoTags(activity: activity)
                        
                        // Description
                        Text(activity.description)
                            .font(.body)
                            .foregroundColor(.black.opacity(0.8))
                        
                        Divider()
                        
                        // Date
                        HStack {
                            Text("Pick a date")
                                .font(.body)
                                .fontWeight(.semibold)
                            Spacer()
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .labelsHidden()
                        }
                        
                        Divider()
                        
                        // Time
                        HStack {
                            Text("Pick a time")
                                .font(.body)
                                .fontWeight(.semibold)
                            Spacer()
                            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        
                        // Plan button
                        Button("Plan this activity"){
                            //TODO: Add logic
                        }
                        .modifier(AccentButtonModifier())
                        
                        // Save to favorites
                        
                        Button {
                            Task {
                                do {
                                    if isFavorite {
                                        try await ActivityService.removeFavorite(activityId: activity.id)
                                    } else {
                                        try await ActivityService.addFavorite(activityId: activity.id)
                                    }
                                    withAnimation {
                                        isFavorite.toggle()
                                    }
                                } catch {
                                    print("Favorite toggle error: \(error)")
                                }
                            }
                        } label: {
                            Label(
                                isFavorite ? "Saved to favorites" : "Save to favorites",
                                systemImage: isFavorite ? "heart.fill" : "heart"
                            )
                        }
                        .contentTransition(.symbolEffect(.replace.downUp.byLayer, options: .nonRepeating))
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(20)
                }
                .background(Color.branco)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .frame(height: 500)
            }
            .padding(.horizontal, 20)
        }
        .task {
            do {
                let favorites = try await ActivityService.fetchFavorites()
                isFavorite = favorites.contains(where: { $0.id == activity.id })
            } catch {
                print("Fetch favorites error: \(error)")
            }
        }
    }
}

#Preview {
    let activity = Activity(id: UUID(), title: "Pottery Workshop", description: "Create something meaningful side by side.", budget: "€€€", duration: 180, isIndoor: true, categoryId: UUID())
    let category = Category(id: UUID(), name: "Creative")
    NavigationStack {
        ActivityDetailView(activity: activity, category: category)
    }
}
