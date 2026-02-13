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
                    }
                    .padding(.vertical, 10)

                }
                .tint(.accent)
                
                Section{
                    NavigationLink("Change password", destination: ChangePasswordView())
                }
                .tint(.primary)
                .padding(.vertical, 10)
                
                Section{
                    Button(role: .destructive) {
                        //TODO: logout logic
                    } label: {
                        Text("Delete Account")
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
