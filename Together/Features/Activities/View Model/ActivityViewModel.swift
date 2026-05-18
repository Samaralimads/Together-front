//
//  ActivityViewModel.swift
//  Together
//
//  Created by Samara Lima da Silva on 18/05/2026.
//

import Foundation

@Observable
class ActivityViewModel {
    var activities: [ActivityService.ActivityResponse] = []
    var categories: [ActivityService.CategoryResponse] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil

    var selectedCategoryName: String? = nil
    var searchText: String = ""
    var filterState: FilterState = FilterState()

    // MARK: - Load everything on appear
    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            async let fetchedCategories = ActivityService.fetchCategories()
            async let fetchedActivities = ActivityService.fetchActivities()
            categories = try await fetchedCategories
            activities = try await fetchedActivities
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Apply filters and search
    func applyFilters() async {
        isLoading = true
        errorMessage = nil

        do {
            activities = try await ActivityService.fetchActivities(
                category: selectedCategoryName,
                search: searchText.isEmpty ? nil : searchText,
                budget: filterState.priceRange.first,
                duration: filterState.duration.first,
                location: filterState.location.first
            )
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Map category name to local image asset
    func imageName(for categoryName: String) -> String {
        switch categoryName {
        case "Food & Drinks": return "Food&Drinks"
        case "Nature":        return "Nature"
        case "Creative":      return "Creative"
        case "Culture":       return "Culture"
        case "Active":        return "Active"
        default:              return "Sparkles"
        }
    }
}
