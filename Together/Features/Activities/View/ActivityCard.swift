//
//  ActivityCard.swift
//  Together
//
//  Created by Samara Lima da Silva on 18/02/2026.
//

import SwiftUI

struct ActivityCard: View {
    
    let activity: Activity
    let category: Category
    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(activity.title)
                    .font(.headline)
                    .foregroundStyle(.preto)
                
                Text(activity.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                
                    InfoTags(activity: activity)
    
            }
            
            Spacer()
            
            Image(category.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                
        }
        .padding()
        .background(.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 5)
    }
}



#Preview {
   let activity = Activity(id: UUID(), title: "Brunch at a Local Café", description: "Enjoy a slow Sunday morning with pastries and coffee.", budget: "€€", duration: 120, isIndoor: true, categoryId: UUID())
   let category = Category(id: UUID(), name: "Food & Drinks", imageName: "Food&Drinks")
   Background {
       ActivityCard(activity: activity, category: category)
           .padding(20)
   }
}

