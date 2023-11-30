//
//  CircleLoadingSpinner.swift
//  Arena
//
//  Created by Yihui Hu on 19/11/23.
//  Adapted from https://github.com/DanielMandea/swiftui-loading-view
//

import SwiftUI

public struct CircleLoadingSpinner: View {
    @State private var rotationAngle: Double = 0
    @State var customColor: String?
    @State var customBgColor: String?
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(Color((customBgColor != nil) ? customBgColor! : "surface-text-secondary"), lineWidth: 4)
                .opacity(0.3)

            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color((customColor != nil) ? customColor! : "text-primary"))
                .rotationEffect(Angle(degrees: rotationAngle))
                .onAppear {
                    withAnimation(Animation.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                        rotationAngle = 360 // Set the initial rotation angle
                    }
                }
        }
        .frame(maxWidth: 16, maxHeight: 16)
    }
}

struct CircleLoadingSpinner_Previews: PreviewProvider {
    static var previews: some View {
        CircleLoadingSpinner()
    }
}
