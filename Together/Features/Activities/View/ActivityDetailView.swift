//
//  ActivityDetailView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI

struct ActivityDetailView: View {
    let activity: Activity

    @State private var selectedDate = Date.now
    @State private var selectedTime = Date.now
    @State private var isFavorite = false
    @State private var isLoadingFavorite = false
    @State private var isProposing = false
    @State private var proposalSuccess = false

    var body: some View {
        Background {
            VStack(spacing: 60) {

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(activity.categoryName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)

                        Text(activity.title)
                            .font(.custom("IvyJournal-Bold", size: 24))
                            .foregroundStyle(Color.black)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer()

                    Image(activity.category.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                }
                .padding(.horizontal, 15)

                VStack(alignment: .leading, spacing: 24) {

                    InfoTags(activity: activity)

                    Text(activity.description)
                        .font(.body)
                        .foregroundStyle(Color.black.opacity(0.8))

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
                                .foregroundStyle(Color.green)
                            Text("Proposal sent to your partner!")
                                .font(.subheadline)
                                .foregroundStyle(Color.green)
                        }
                    }

                    Button(isProposing ? "Sending..." : "Plan this activity", action: proposeActivity)
                        .modifier(AccentButtonModifier())
                        .disabled(isProposing)

                    Button(action: toggleFavorite) {
                        Label(
                            isFavorite ? "Saved to favorites" : "Save to favorites",
                            systemImage: isFavorite ? "heart.fill" : "heart"
                        )
                    }
                    .contentTransition(.symbolEffect(.replace.downUp.byLayer, options: .nonRepeating))
                    .frame(maxWidth: .infinity)
                    .disabled(isLoadingFavorite)
                }
                .padding(20)
                .background(Color.branco)
                .clipShape(.rect(cornerRadius: 30))
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

    // MARK: - Actions
    private func proposeActivity() {
        Task {
            isProposing = true
            let finalDate = combinedDate(date: selectedDate, time: selectedTime)

            do {
                _ = try await PlannedActivityService.propose(activityId: activity.id, date: finalDate)
                proposalSuccess = true
            } catch {
                print("Propose error: \(error)")
            }
            isProposing = false
        }
    }

    private func toggleFavorite() {
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
    }

    // MARK: - Helpers
    private func combinedDate(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        return calendar.date(from: components) ?? date
    }
}

#Preview {
    let activity = Activity(
        id: UUID(),
        title: "Pottery Workshop",
        description: "Create something meaningful side by side.",
        budget: "€€€",
        duration: 180,
        isIndoor: true,
        categoryId: UUID(),
        categoryName: "Creative"
    )
    NavigationStack {
        ActivityDetailView(activity: activity)
    }
}
