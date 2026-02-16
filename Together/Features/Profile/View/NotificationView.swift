//
//  NotificationView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI

struct NotificationView: View {
    @State private var partnerResponse = true
    @State private var upcomingActivities = true
    @State private var specialDates = true
    
    var body: some View {
        
        Background{
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Partner response")
                            
                            Spacer()
                            
                            Toggle("", isOn: $partnerResponse)
                                .labelsHidden()
                        }
                        
                        Text("Get notified about your partner's reply to an activity")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Upcoming activities")
                            
                            Spacer()
                            
                            Toggle("", isOn: $upcomingActivities)
                                .labelsHidden()
                        }
                        
                        Text("Get reminded of your upcoming booked activity")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Special dates")
                            
                            Spacer()
                            
                            Toggle("", isOn: $specialDates)
                                .labelsHidden()
                        }
                        
                        Text("We'll notify you before your anniversary or any special date")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 3)
            }
            .scrollContentBackground(.hidden)
            .tint(.accent)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Notifications")
                        .font(.title.weight(.semibold))
                }
            }
        }
    }
}

#Preview {
    NotificationView()
}
