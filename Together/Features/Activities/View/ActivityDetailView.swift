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
    @State private var isLoadingFavorite = false
    @State private var isProposing = false
    @State private var proposalSuccess = false

    var body: some View {
        Background {
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

//                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        InfoTags(activity: activity)

                        Text(activity.description)
                            .font(.body)
                            .foregroundColor(.black.opacity(0.8))

                        Divider()

                        HStack {
                            Text("Pick a date")
                                .font(.body)
                                .fontWeight(.semibold)
                            Spacer()
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .labelsHidden()
                        }

                        Divider()

                        HStack {
                            Text("Pick a time")
                                .font(.body)
                                .fontWeight(.semibold)
                            Spacer()
                            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()

                        }
                        .padding(.bottom, 10)

                        if proposalSuccess {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Proposal sent to your partner!")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }
                        }

                        Button(isProposing ? "Sending..." : "Plan this activity") {
                            Task {
                                isProposing = true
                                // Combine date and time
                                let calendar = Calendar.current
                                let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
                                let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
                                var combined = DateComponents()
                                combined.year = dateComponents.year
                                combined.month = dateComponents.month
                                combined.day = dateComponents.day
                                combined.hour = timeComponents.hour
                                combined.minute = timeComponents.minute
                                let finalDate = calendar.date(from: combined) ?? selectedDate

                                do {
                                    _ = try await PlannedActivityService.propose(activityId: activity.id, date: finalDate)
                                    proposalSuccess = true
                                } catch {
                                    print("Propose error: \(error)")
                                }
                                isProposing = false
                            }
                        }
                        .modifier(AccentButtonModifier())
                        .disabled(isProposing)

                        Button {
                            guard !isLoadingFavorite else { return }
                            Task {
                                isLoadingFavorite = true
                                do {
                                    if isFavorite {
                                        try await ActivityService.removeFavorite(activityId: activity.id)
                                    } else {
                                        try await ActivityService.addFavorite(activityId: activity.id)
                                    }
                                    withAnimation { isFavorite.toggle() }
                                } catch {
                                    print("Favorite toggle error: \(error)")
                                }
                                isLoadingFavorite = false
                            }
                        } label: {
                            Label(
                                isFavorite ? "Saved to favorites" : "Save to favorites",
                                systemImage: isFavorite ? "heart.fill" : "heart"
                            )
                        }
                        .contentTransition(.symbolEffect(.replace.downUp.byLayer, options: .nonRepeating))
//                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                        .disabled(isLoadingFavorite)
                    }
                    .padding(20)
//                }
                .background(Color.branco)
                .clipShape(RoundedRectangle(cornerRadius: 30))
//                .frame(height: 500)
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
