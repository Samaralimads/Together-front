//
//  RelationshipStatusView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI

struct RelationshipStatusView: View {
    @State private var selectedOption: String? = "Dating"
    
    
    var body: some View {
        Background{
            
            WhiteCard(title: "Describe your relationship", description: "Help us personalize your experience based on your relationship stage."){
                
                
                VStack(spacing: 16) {
                    RelationshipButton(
                        title: "Dating",
                        isSelected: selectedOption == "Dating",
                        action: { selectedOption = "Dating" }
                    )
                    
                    RelationshipButton(
                        title: "Engaged",
                        isSelected: selectedOption == "Engaged",
                        action: { selectedOption = "Engaged" }
                    )
                    
                    RelationshipButton(
                        title: "Married",
                        isSelected: selectedOption == "Married",
                        action: { selectedOption = "Married" }
                    )
                }
                .padding(.top, 30)
            }
        }
    }
}

struct RelationshipButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : .preto)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    Group {
                        if isSelected {
                            Image("buttonBG")
                                .resizable()
                                .scaledToFill()
                        } else {
                            Color(white: 0.94)
                        }
                    }
                )
                .cornerRadius(32)
                .clipped()
        }
    }
}

#Preview {
    RelationshipStatusView()
}
