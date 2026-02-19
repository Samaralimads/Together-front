//
//  ProfileView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var showSettings = false
    @State private var showNoPairAlert = false
    @State private var showInvitePartner = false
    @State private var showEditAnniversary = false
    @State private var showAddDate = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    // Mock data
    @State private var partner1Name = "Sarah"
    @State private var partner2Name = "John" // Empty means not paired
    @State private var anniversary = Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 4))!
    @State private var importantDates: [ImportantDate] = [
        ImportantDate(id: UUID(), label: "Birthday - Sarah", date: Date()),
        ImportantDate(id: UUID(), label: "First Date", date: Date())
    ]
    
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
                            partner1Initial: String(partner1Name.prefix(1).uppercased()),
                            partner2Initial: partner2Name.isEmpty ? nil : String(partner2Name.prefix(1).uppercased()),
                            profileImage: selectedImage,
                            onCameraClick: {
                                showImagePicker = true
                            },
                            onAddPartnerClick: {
                                if partner2Name.isEmpty {
                                    showNoPairAlert = true
                                }
                            }
                        )
                        
                        Text("\(partner1Name)\(partner2Name.isEmpty ? "" : " & \(partner2Name)")")
                            .font(.custom("IvyJournal-Bold", size: 35))
                            .foregroundColor(.white)
                        
                        TogetherForCard(anniversary: anniversary) {
                            showEditAnniversary = true
                        }
                        
                        ImportantDatesCard(
                            anniversary: anniversary,
                            importantDates: $importantDates,
                            onAddDate: {
                                showAddDate = true
                            }
                        )
                        
                        StatsCard()
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
            .navigationDestination(isPresented: $showInvitePartner) {
                ShareCodePairingView()
            }
            .alert("No Partner Paired", isPresented: $showNoPairAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Invite") {
                    showInvitePartner = true
                }
            } message: {
                Text("You haven't paired with a partner yet. Would you like to invite them?")
            }
            .sheet(isPresented: $showEditAnniversary) {
                EditAnniversarySheet(anniversary: $anniversary)
            }
            .sheet(isPresented: $showAddDate) {
                AddImportantDateSheet(importantDates: $importantDates)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }


#Preview {
    ProfileView()
}



