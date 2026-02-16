//
//  StatsCard.swift
//  Together
//
//  Created by Samara Lima da Silva on 16/02/2026.
//
import SwiftUI

struct StatsCard: View {
    // TODO: - Add an alternate view if couple not paired
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Stats")
                    .font(.custom("IvyJournal-Bold", size: 24))
                
                Spacer()
                
                Menu {
                    Button("This year") { }
                    Button("This month") { }
                    Button("All time") { }
                } label: {
                    HStack(spacing: 5) {
                        Text("This year")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.accent)
                    }
                }
            }
            
            DatesCompletedRow(
                totalDates: 50
            )
            
            Divider()
            
            // Planned by section
            VStack(spacing: 12) {
                Text("Planned by")
                    .font(.body)
                    .fontWeight(.medium)
                
                VStack(spacing: 15) {
                    PlannedByRow(
                        name: "Sarah",
                        color: .lilas,
                        completed: 40,
                        total: 50
                    )
                    
                    PlannedByRow(
                        name: "John",
                        color: .verde,
                        completed: 10,
                        total: 50
                    )
                }
            }
            
            Divider()
            
            // Where section
            VStack(spacing: 12) {
                Text("Where")
                    .font(.body)
                    .fontWeight(.medium)
                
                WhereRow(
                    indoors: 22,
                    outdoors: 28
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
        )
    }
}

struct DatesCompletedRow: View {
    let totalDates: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(totalDates)")
                .font(.custom("IvyJournal-Bold", size: 40))
            
            Text("Dates Completed")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}


struct PlannedByRow: View {
    let name: String
    let color: Color
    let completed: Int
    let total: Int
    
    private var initial: String {
        String(name.prefix(1)).uppercased()
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(color, lineWidth: 2)
                    .frame(width: 50, height: 50)
                
                Text(initial)
                    .font(.title3)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.subheadline)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color.opacity(0.2))
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color)
                            .frame(width: geometry.size.width * CGFloat(completed) / CGFloat(total), height: 12)
                    }
                }
                .frame(height: 12)
            }
            
            Text("\(completed)/\(total)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct WhereRow : View {
    let indoors: Int
    let outdoors: Int
    
    var body: some View {
        
        HStack(spacing: 40) {
             VStack(spacing: 8) {
                 Text("\(indoors)")
                     .font(.custom("IvyJournal-Bold", size: 30))
                 
                 Text("Indoors")
                     .font(.subheadline)
                     .foregroundColor(.secondary)
             }
             
             VStack(spacing: 8) {
                 Text("\(outdoors)")
                     .font(.custom("IvyJournal-Bold", size: 30))
                 
                 Text("Outdoors")
                     .font(.subheadline)
                     .foregroundColor(.secondary)
             }
         }
     }
}


#Preview{
    Background{
        StatsCard()
            .padding(20)
    }
}

