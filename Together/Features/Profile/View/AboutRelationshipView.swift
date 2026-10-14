//
//  AboutRelationshipView.swift
//  Together
//
//  Created by Samara Lima da Silva on 13/02/2026.
//

import SwiftUI

struct AboutRelationshipView: View {
    @State private var viewModel = ProfileViewModel()

    var body: some View {
        Background{

            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.isPaired {
                    PartnerView(viewModel: viewModel)
                } else {
                    NoPartnerView()
                }
            }
        }
        .task { await viewModel.load() }
    }
}


struct PartnerView: View {
    let viewModel: ProfileViewModel
    @State private var showUnpairAlert = false
    @State private var showUnpairUnavailableAlert = false

    var body: some View {

        List{
            Section{
                HStack {
                    Text("Partner")

                    Spacer()

                    Text(viewModel.couple?.partner?.firstName ?? "")
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Together Since")

                    Spacer()

                    Text(viewModel.anniversaryDate, style: .date)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.secondary)
                }



            }
            .padding(.vertical, 10)
            .tint(.accent)


            Section{
                Button(role: .destructive) {
                    showUnpairAlert = true
                } label: {
                    Text("Unpair partner")
                }
                .alert("Unpair Partner", isPresented: $showUnpairAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Unpair", role: .destructive) {
                        // Unpairing isn't implemented on the backend yet.
                        showUnpairUnavailableAlert = true
                    }
                } message: {
                    Text("Are you sure you want to unpair from \(viewModel.couple?.partner?.firstName ?? "your partner")? You'll need to pair again to reconnect.")
                }
                .alert("Not Available Yet", isPresented: $showUnpairUnavailableAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Unpairing isn't supported yet — it's on the list.")
                }

            }
            .padding(.vertical, 9)


        }
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Your Relationship")
                    .font(.title.weight(.semibold))
            }


        }
    }
}

struct NoPartnerView: View{

    var body: some View {

        WhiteCard(title: "You are not paired", description:"You haven’t connected with your partner yet. Pair up to view your relationship details, track milestones, and plan meaningful moments together.") {


            NavigationLink("Invite my partner") {
                ShareCodePairingView()
            }
            .modifier(AccentButtonModifier())
            .padding(.top, 40)

        }

    }
}

#Preview {
    AboutRelationshipView()
}
