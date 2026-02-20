//
//  AnniversaryView.swift
//  Together
//
//  Created by Samara Lima da Silva on 10/02/2026.
//

import SwiftUI

struct AnniversaryView: View {
    @State private var anniversary: Date?
    
    var body: some View {
        Background{
            
            WhiteCard(title: "How long have you been together?", description:"Choose the date your journey began. We’ll use it to celebrate your milestones." ){
                
                InputField(placeholder: "Together since:", date: $anniversary)
                    .padding(.vertical, 40)
                
                Button("Next"){
                    
                }
                .modifier(AccentButtonModifier())
                
            }
        }
    }
}

#Preview {
    AnniversaryView()
}
