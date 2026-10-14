//
//  DashboardViewModelTests.swift
//  TogetherTests
//

import XCTest
@testable import Together

final class DashboardViewModelTests: XCTestCase {

    func testIsPairedReflectsCouplePartner() {
        let viewModel = DashboardViewModel()
        XCTAssertFalse(viewModel.isPaired)

        viewModel.couple = Couple(
            id: UUID(),
            relationshipStartDate: "2025-01-01",
            partner: Partner(id: UUID(), firstName: "Henri")
        )
        XCTAssertTrue(viewModel.isPaired)
    }

    func testIsPairedIsFalseWhenCoupleHasNoPartnerYet() {
        let viewModel = DashboardViewModel()
        viewModel.couple = Couple(id: UUID(), relationshipStartDate: "2025-01-01", partner: nil)
        XCTAssertFalse(viewModel.isPaired)
    }

    func testFirstNameFallsBackToEmptyStringWhenNoUser() {
        let viewModel = DashboardViewModel()
        XCTAssertEqual(viewModel.firstName, "")

        viewModel.user = User(
            id: UUID(),
            firstName: "Sarah",
            birthDate: "1998-04-12",
            email: "sarah@example.com",
            profilePicture: nil
        )
        XCTAssertEqual(viewModel.firstName, "Sarah")
    }

    func testPartnerNameFallsBackToEmptyStringWhenNotPaired() {
        let viewModel = DashboardViewModel()
        XCTAssertEqual(viewModel.partnerName, "")

        viewModel.couple = Couple(
            id: UUID(),
            relationshipStartDate: "2025-01-01",
            partner: Partner(id: UUID(), firstName: "Henri")
        )
        XCTAssertEqual(viewModel.partnerName, "Henri")
    }
}
