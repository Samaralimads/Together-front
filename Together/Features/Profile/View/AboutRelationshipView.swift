//
//  AboutRelationshipView.swift
//  Together
//
//  Created by Samara Lima da Silva on 13/02/2026.
//

import SwiftUI

struct AboutRelationshipView: View {
    @State private var hasPartner = true
    
    var body: some View {
        Background{
            
            if hasPartner {
                PartnerView()
            } else {
                NoPartnerView()
            }
        }
    }
}


struct PartnerView: View {
    @State private var partner = "John"
    @State private var dateOfBirth = Date()
    @State private var anniversary = Date()
    @State private var showUnpairAlert = false
    
    var body: some View {
        
        List{
            Section{
                HStack {
                    Text("Partner")
                    
                    Spacer()
                    
                    Text("\(partner)")
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Date of Birth")
                    
                    Spacer()
                    
                    Text("\(dateOfBirth, style: .date)")
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Together Since")
                    
                    Spacer()
                    
                    Text("\(anniversary, style: .date)")
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
                }        .alert("Unpair Partner", isPresented: $showUnpairAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Unpair", role: .destructive) {
                        // TODO: Handle unpairing
                    }
                } message: {
                    Text("Are you sure you want to unpair from \(partner)? You'll need to pair again to reconnect.")
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
