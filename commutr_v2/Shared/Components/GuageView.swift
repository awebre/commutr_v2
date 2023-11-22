//
//  GuageView.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/21/23.
//

import SwiftUI

struct GuageView: View {
    var percentage: Double
    var color = Color(.accent)
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(
                    color.opacity(0.40),
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-180))
            
            Circle()
                .trim(from: 0, to: min(0.5 * CGFloat(percentage), 0.5))
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-180))
        }.padding(.horizontal, 10)
    }
}

#Preview {
    GuageView(percentage: 0.66)
}
