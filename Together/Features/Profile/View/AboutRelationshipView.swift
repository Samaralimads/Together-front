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
                    //TODO: alert and unpair
                } label: {
                    Text("Unpair partner")
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
    @State private var showInvitationView: Bool = false
    
    var body: some View {
        
        WhiteCard(title: "You are not paired", description:"You haven’t connected with your partner yet. Pair up to view your relationship details, track milestones, and plan meaningful moments together.") {
            
            
            AccentButton(title: "Invite my partner") {
                showInvitationView = true
            }
            .padding(.top, 40)
            
        }
        .navigationDestination(isPresented: $showInvitationView) {
            ShareCodePairingView()
        }
        
    }
    
    
}


#Preview {
    AboutRelationshipView()
}
