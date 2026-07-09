//
//  ActivityView.swift
//  Together
//
//  Created by Samara Lima da Silva on 17/02/2026.
//

import SwiftUI

struct ActivityView: View {
    @State private var viewModel = ActivityViewModel()
    @State private var showFilters = false

    var body: some View {
        Background {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    searchBar
                    categoriesRow
                    listOfActivities
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .task {
            await viewModel.load()
        }
    }
}

// MARK: - Components
private extension ActivityView {

    var searchBar: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.black.opacity(0.6))

                TextField("Search an activity", text: $viewModel.searchText)
                    .textFieldStyle(.plain)
                    .foregroundStyle(Color.black)
                    .onSubmit {
                        Task { await viewModel.applyFilters() }
                    }

                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.searchText = ""
                        Task { await viewModel.applyFilters() }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.gray)
                    }
                }
            }
            .padding()
            .background(.white)
            .clipShape(Capsule())

            Button {
                showFilters = true
            } label: {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundStyle(Color.black.opacity(0.6))
                        .padding()
                        .background(Color.white)
                        .clipShape(Capsule())

                    if viewModel.filterState.totalSelected > 0 {
                        Text("\(viewModel.filterState.totalSelected)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                            .frame(width: 20, height: 20)
                            .background(Color(.accent))
                            .clipShape(Circle())
                            .offset(x: 4, y: -3)
                    }
                }
            }
            .fullScreenCover(isPresented: $showFilters) {
                FiltersView(filterState: $viewModel.filterState)
                    .onDisappear {
                        Task { await viewModel.applyFilters() }
                    }
            }
        }
    }

    var categoriesRow: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                categoryChip(title: "All", isSelected: viewModel.selectedCategoryName == nil, imageName: "Sparkles") {
                    viewModel.selectedCategoryName = nil
                    Task { await viewModel.applyFilters() }
                }

                ForEach(viewModel.categories) { category in
                    categoryChip(
                        title: category.name,
                        isSelected: viewModel.selectedCategoryName == category.name,
                        imageName: category.imageName
                    ) {
                        viewModel.selectedCategoryName = category.name
                        Task { await viewModel.applyFilters() }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
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
                    .foregroundStyle(Color.white)
                    .fontWeight(isSelected ? .bold : .medium)
            }
        }
    }

    var listOfActivities: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
            } else if viewModel.activities.isEmpty {
                Text("No activities found.")
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
            } else {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.activities) { activity in
                        NavigationLink(destination: ActivityDetailView(activity: activity)) {
                            ActivityCard(activity: activity)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ActivityView()
}
