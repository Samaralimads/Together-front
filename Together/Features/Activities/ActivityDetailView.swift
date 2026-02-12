//
//  ActivityDetailView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI

struct ActivityDetailView: View {
    @State private var isFavorite = false

       var body: some View {
           VStack {
               Button {
                   withAnimation {
                       isFavorite.toggle()
                   }
               } label: {
                   Label("Save to favorites", systemImage: isFavorite ? "heart.fill": "heart")
               }
               .contentTransition(.symbolEffect(.replace.downUp.byLayer, options: .nonRepeating))
               
               Button {
                   withAnimation {
                       isFavorite.toggle()
                   }
               } label: {
                   Label("Save to favorites", systemImage: isFavorite ? "heart.fill": "heart")
               }
               .contentTransition(.symbolEffect(.replace.upUp.byLayer, options: .nonRepeating))
           }
           .font(.largeTitle)
       }
   }

#Preview {
    ActivityDetailView()
}
