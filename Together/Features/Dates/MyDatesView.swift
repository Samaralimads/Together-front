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

    // TODO: Replace with ViewModel data
    @State private var favorites: [Activity] = []
    @State private var upcoming: [Activity] = []
    @State private var history: [Activity] = []

    private var currentList: [Activity] {
        switch selectedTab {
        case .favorites: return favorites
        case .upcoming:  return upcoming
        case .history:   return history
        }
    }

    var body: some View {
        Background {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Dates")
                            .font(.custom("IvyJournal-Bold", size: 30))
                            .foregroundColor(.preto)

                        Text("Keep track of your current, past or favorite activities.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.branco)
                    }

                    tabPicker

                    if currentList.isEmpty {
                        emptyState
                    } else {
                        VStack(spacing: 16) {
                            ForEach(currentList) { activity in
                                let category = Category(id: activity.categoryId, name: "", imageName: "Sparkles")
                                NavigationLink(destination: ActivityDetailView(activity: activity, category: category)) {
                                    ActivityCard(activity: activity, category: category)
                                }
                            }
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }

    private var tabPicker: some View {
        HStack(spacing: 0) {
            tabButton(title: "FAVORITES", icon: "heart.fill", tab: .favorites)
            tabButton(title: "UPCOMING", icon: "calendar", tab: .upcoming)
            tabButton(title: "HISTORY", icon: "clock.arrow.circlepath", tab: .history)
        }
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
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
            .foregroundColor(isSelected ? .preto : .preto.opacity(0.45))
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

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text(emptyIcon)
                .font(.system(size: 40))

            Text(emptyTitle)
                .font(.custom("IvyJournal-Bold", size: 20))
                .foregroundColor(.preto)

            Text(emptySubtitle)
                .font(.system(size: 14, weight: .light))
                .foregroundColor(.preto.opacity(0.6))
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
        case .favorites: return "🤍"
        case .upcoming:  return "📅"
        case .history:   return "🌟"
        }
    }

    private var emptyTitle: String {
        switch selectedTab {
        case .favorites: return "No favorites yet"
        case .upcoming:  return "Nothing planned"
        case .history:   return "No dates yet"
        }
    }

    private var emptySubtitle: String {
        switch selectedTab {
        case .favorites: return "Save activities you love and find them here."
        case .upcoming:  return "Plan your next date and it'll show up here."
        case .history:   return "Your completed activities will appear here."
        }
    }
}

#Preview {
    NavigationStack {
        MyDatesView()
    }
}
