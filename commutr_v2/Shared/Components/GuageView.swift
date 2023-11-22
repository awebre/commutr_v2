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
    @State var drawingStroke = false
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(
                    color.opacity(0.40),
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-225))
            
            Circle()
                .trim(from: 0, to: drawingStroke ? min(0.75 * CGFloat(percentage), 0.5) : .leastNonzeroMagnitude)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .animation(Animation.easeIn(duration: 2).delay(0.25), value: drawingStroke)

                .rotationEffect(.degrees(-225))
        }
        .padding(15)
        .onAppear(){
            drawingStroke = true
        }
    }
}

#Preview {
    GuageView(percentage: 0.66)
}
