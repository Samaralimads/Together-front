//
//  BirthdayView.swift
//  Together
//
//  Created by Samara Lima da Silva on 10/02/2026.
//

import SwiftUI

struct BirthdayView: View {
    @State private var birthday: Date?
    
    var body: some View {
        Background{
            
            WhiteCard(title: "One last thing", description:"Just need your birthday and we're all set!" ){
                
                InputField(
                    placeholder: "My birthday is",
                    date: $birthday
                )
                .padding(.vertical, 40)
                
                AccentButton(title: "Next"){
                    
                }
                
            }
        }
    }
}
#Preview {
    BirthdayView()
}
