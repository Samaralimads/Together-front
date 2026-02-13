//
//  SettingsView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI
import StoreKit


struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        Background{
            
            List {
                
                Section {
                    NavigationLink("About you") {
                        AboutYouView()
                    }
                    
                    NavigationLink("Your relationship") {
                        AboutRelationshipView()
                    }
                    
                    NavigationLink("Notification Settings") {
                        NotificationView()
                    }
                    
                    Button("Help & Support") {
                        //TODO: send email to support
                    }

                    
                    Button("Leave us a review") {
                        requestReview()
                    }
                    

                }
                .tint(.primary)
                .padding(.vertical, 10)
                .listRowBackground(Color.branco)                
                
                Section {
                    Button(role: .destructive) {
                        //TODO: logout logic
                    } label: {
                        Text("Log out")
                    }
                }
                .padding(.vertical, 8)
                .listRowBackground(Color.branco)
                
            }
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.title.weight(.semibold))
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
