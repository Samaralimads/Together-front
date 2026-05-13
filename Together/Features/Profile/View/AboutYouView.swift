//
//  AboutYouView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI

struct AboutYouView: View {
    @State private var name = "Samara"
    @State private var dateOfBirth = Date()
    @State private var email = "samara@gmail.com"
    @State private var showDeleteAccountAlert = false
    
    var body: some View {
        Background{
            
            List{
                
                Section{
                    HStack {
                        Text("Name")
                        
                        Spacer()
                        
                        TextField(
                            "Enter your name",
                            text: $name
                        )
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 10)
                    
                    
                    DatePicker(
                        "Date of Birth",
                        selection: $dateOfBirth,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .tint(.accent)
                    .padding(.vertical, 2)
                    
                    
                    
                    HStack {
                        Text("Email")
                        
                        Spacer()
                        
                        TextField(
                            "Enter your email",
                            text: $email
                        )
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 10)
                    
                }
                .tint(.accent)
                
                Section{
                    NavigationLink("Reset password",
                                   destination: ResetCodeView(email: email)
)
                }
                .tint(.primary)
                .padding(.vertical, 10)
                
                Section{
                    Button(role: .destructive) {
                        showDeleteAccountAlert = true
                    } label: {
                        Text("Delete Account")
                    }
                    .alert("Delete Account", isPresented: $showDeleteAccountAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            // TODO: Handle account deletion
                        }
                    } message: {
                        Text("This action cannot be undone. All your data will be permanently deleted.")
                    }
                }
                .padding(.vertical, 9)
                
                
            }
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("About You")
                        .font(.title.weight(.semibold))
                }
                
                
            }
        }
    }
}
#Preview {
    AboutYouView()
}
