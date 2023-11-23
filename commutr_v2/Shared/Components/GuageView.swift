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
    @State var strokeFillPercentage = CGFloat.leastNonzeroMagnitude
    @State var canAnimate = false
    
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
                .trim(from: 0, to: strokeFillPercentage)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .animation(canAnimate ? Animation.easeInOut(duration: 2).delay(0.25) : nil, value: strokeFillPercentage)
                .rotationEffect(.degrees(-225))
        }
        .padding(15)
        .onAppear(){
            //Hack to stop view from animating in from the side
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                canAnimate = true
                strokeFillPercentage = min(0.75 * CGFloat(percentage), 0.5)
            }
        }
    }
}

#Preview {
    GuageView(percentage: 0.66)
}
