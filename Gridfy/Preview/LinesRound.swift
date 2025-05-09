//
//  LinesRound.swift
//  Gridfy
//
//  Created by Slava on 01.05.2022.
//

import SwiftUI

/*------------------------------------------------
---- LINE HORIZONTAL
------------------------------------------------*/

struct lineH: View {
    let direction: String
    var body: some View {
        LinePatchH()
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 4]))
            .frame(height: 1)
            .opacity(0.6)
            .rotation3DEffect(.degrees (direction == "right" ? 180: 0), axis: (x: 0, y: 1, z: 0))
    }
}

struct LinePatchH: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 30, y: -15))
        path.addQuadCurve(to: CGPoint(x: 50, y: 0), control: CGPoint(x: 30, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

/*------------------------------------------------
---- LINE VERTICAL
------------------------------------------------*/

struct lineV: View {
    let direction: String
    var body: some View {
        LinePatchV()
            .stroke(style: StrokeStyle(lineWidth: 1))
            .frame(width: 1)
            .opacity(0.15)
            .rotation3DEffect(.degrees (direction == "top" ? 0: 180), axis: (x: 1, y: 0, z: 0))
    }
}
struct LinePatchV: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: -20, y: 30))
        path.addQuadCurve(to: CGPoint(x: 0, y: 50), control: CGPoint(x: 0, y: 30))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
    }
}

/*------------------------------------------------
---- DOTS LINE PREVIEW
------------------------------------------------*/

struct dotsLineWidth: View {
    let text: String
    let spacingTop: CGFloat = 5
    var body: some View {
        HStack() {
            lineH(direction: "left")
            Text(String(text))
                .font(.system(size: 12, weight: .bold))
            lineH(direction: "right")
        }
        .padding(.top, spacingTop)
        .padding(.horizontal, 20)
    }
}
