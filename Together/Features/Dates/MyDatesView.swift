//
//  MyDatesView.swift
//  Together
//
//  Created by Samara Lima da Silva on 20/02/2026.
//

import SwiftUI

enum MyDatesTab {
    case favorites, upcoming, history
}

struct MyDatesView: View {
    @State private var selectedTab: MyDatesTab = .favorites
    @State private var favorites: [Activity] = []
    @State private var upcoming: [PlannedActivity] = []
    @State private var history: [PlannedActivity] = []
    @State private var isLoading = false
    @State private var errorMessage: String? = nil

    var body: some View {
        Background {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Dates")
                            .font(.custom("IvyJournal-Bold", size: 30))
                            .foregroundStyle(Color.preto)

                        Text("Keep track of your current, past or favorite activities.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(Color.branco)
                    }

                    tabPicker

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }

                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                    } else {
                        switch selectedTab {
                        case .favorites:
                            if favorites.isEmpty { emptyState } else { favoritesList }
                        case .upcoming:
                            if upcoming.isEmpty { emptyState } else { upcomingList }
                        case .history:
                            if history.isEmpty { emptyState } else { historyList }
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .task { await loadAll() }
        .refreshable { await loadAll() }
    }

    // MARK: - Load
    private func loadAll() async {
        isLoading = true
        errorMessage = nil
        let now = Date.now

        do { favorites = try await ActivityService.fetchFavorites() }
        catch {
            print("Favorites error: \(error)")
            errorMessage = "Could not load your favorites. Pull down to try again."
        }

        do {
            let all = try await PlannedActivityService.getCoupleActivities()
            upcoming = all
                .filter { $0.isAccepted && ($0.parsedDate ?? .distantPast) > now }
                .sorted { ($0.parsedDate ?? .distantPast) < ($1.parsedDate ?? .distantPast) }
            history = all
                .filter { $0.isAccepted && ($0.parsedDate ?? .distantFuture) <= now }
                .sorted { ($0.parsedDate ?? .distantPast) > ($1.parsedDate ?? .distantPast) }
        } catch {
            print("Planned activities error: \(error)")
            errorMessage = "Could not load your dates. Pull down to try again."
        }

        isLoading = false
    }

    // MARK: - Lists
    private var favoritesList: some View {
        VStack(spacing: 16) {
            ForEach(favorites) { activity in
                NavigationLink(destination: ActivityDetailView(activity: activity)) {
                    ActivityCard(activity: activity)
                }
            }
        }
    }

    private var upcomingList: some View {
        VStack(spacing: 16) {
            ForEach(upcoming) { planned in
                UpcomingDateCard(planned: planned)
            }
        }
    }

    private var historyList: some View {
        VStack(spacing: 16) {
            ForEach(history) { planned in
                UpcomingDateCard(planned: planned)
            }
        }
    }

    // MARK: - Tab Picker
    private var tabPicker: some View {
        HStack(spacing: 0) {
            tabButton(title: "FAVORITES", icon: "heart.fill", tab: .favorites)
            tabButton(title: "UPCOMING", icon: "calendar", tab: .upcoming)
            tabButton(title: "HISTORY", icon: "clock.arrow.circlepath", tab: .history)
        }
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
    }

    private func tabButton(title: String, icon: String, tab: MyDatesTab) -> some View {
        let isSelected = selectedTab == tab
        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                Text(title)
                    .font(.system(size: 11, weight: .bold))
            }
            .foregroundStyle(isSelected ? Color.preto : Color.preto.opacity(0.45))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.branco)
                            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                }
            )
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 12) {
            Text(emptyIcon).font(.system(size: 40))
            Text(emptyTitle)
                .font(.custom("IvyJournal-Bold", size: 20))
                .foregroundStyle(Color.preto)
            Text(emptySubtitle)
                .font(.system(size: 14, weight: .light))
                .foregroundStyle(Color.preto.opacity(0.6))
                .multilineTextAlignment(.center)
            NavigationLink(destination: ActivityView()) {
                Text("Discover activities")
            }
            .modifier(AccentButtonModifier())
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    private var emptyIcon: String {
        switch selectedTab {
        case .favorites: "🤍"
        case .upcoming:  "📅"
        case .history:   "🌟"
        }
    }

    private var emptyTitle: String {
        switch selectedTab {
        case .favorites: "No favorites yet"
        case .upcoming:  "Nothing planned"
        case .history:   "No dates yet"
        }
    }

    private var emptySubtitle: String {
        switch selectedTab {
        case .favorites: "Save activities you love and find them here."
        case .upcoming:  "Plan your next date and it'll show up here."
        case .history:   "Your completed activities will appear here."
        }
    }
}

#Preview {
    NavigationStack {
        MyDatesView()
    }
}
