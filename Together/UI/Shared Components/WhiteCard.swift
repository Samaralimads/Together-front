//
//  WhiteCard.swift
//  Together
//
//  Created by Samara Lima da Silva on 10/02/2026.
//

import SwiftUI


struct WhiteCard<Content: View>: View {
    
    let title: String
    let description: String
    let content: Content
    
    init(
        title: String,
        description: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.description = description
        self.content = content()
    }
    
    
    
    var body: some View {
        ScrollView{
            
            
            VStack() {
                
                VStack(spacing: 15) {
                    
                    Text(title)
                        .font(.custom("IvyJournal-Bold", size: 30))
                    
                    Text(description)
                        .font(.system(size: 15, weight: .light))
                        .padding(.horizontal, 10)
                    
                }
                .multilineTextAlignment(.center)
                
                
                
                content
                
            }
            .padding(.top, 40)
            .padding(.bottom, 30)
            .padding(.horizontal, 10)
            .frame(maxWidth: 380)
            .frame(minHeight: 400)
            .background(Color.branco)
            .cornerRadius(32)
            .padding()
        }
    }
}



#Preview {
    WhiteCard(title: "This is the title that is longer now to test", description: "This is a short description, longer now to test the spacing"){
        Spacer()
        Text("And this is the content of the card")
    }.background(Color.blue.opacity(0.2))
}
