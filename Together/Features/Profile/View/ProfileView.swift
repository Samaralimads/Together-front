//
//  ProfileView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @State private var showSettings = false
    @State private var showNoPairAlert = false
    @State private var showInvitePartner = false
    @State private var showEditAnniversary = false
    @State private var showAddDate = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var anniversary = Date()

    var body: some View {
        Background {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, -18)

                    ProfileAvatarsCard(
                        partner1Initial: viewModel.partner1Initial,
                        partner2Initial: viewModel.partner2Initial,
                        profileImage: selectedImage,
                        onCameraClick: {
                            showImagePicker = true
                        },
                        onAddPartnerClick: {
                            if !viewModel.isPaired {
                                showNoPairAlert = true
                            }
                        }
                    )

                    Text(viewModel.displayName)
                        .font(.custom("IvyJournal-Bold", size: 35))
                        .foregroundColor(.white)

                    TogetherForCard(anniversary: anniversary) {
                        showEditAnniversary = true
                    }

                    ImportantDatesCard(
                        anniversary: anniversary,
                        importantDates: $viewModel.importantDates,
                        onAddDate: { showAddDate = true },
                        onDelete: { date in Task { await viewModel.deleteImportantDate(date) } },
                        onEdit: { date in Task { await viewModel.updateImportantDate(date) } }
                    )

                    StatsCard()

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
            }
        }
        .task {
            await viewModel.load()
            anniversary = viewModel.anniversaryDate
        }
        .navigationDestination(isPresented: $showSettings) {
            SettingsView()
        }
        .navigationDestination(isPresented: $showInvitePartner) {
            ShareCodePairingView()
        }
        .alert("No Partner Paired", isPresented: $showNoPairAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Invite") { showInvitePartner = true }
        } message: {
            Text("You haven't paired with a partner yet. Would you like to invite them?")
        }
        .sheet(isPresented: $showEditAnniversary) {
            EditAnniversarySheet(anniversary: $anniversary)
        }
        .sheet(isPresented: $showAddDate) {
            AddImportantDateSheet { label, date in
                Task { await viewModel.addImportantDate(label: label, date: date) }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

#Preview {
    ProfileView()
}
