//
//  PreviewMain.swift
//  Gridfy
//
//  Created by Slava on 30.04.2022.
//

import SwiftUI

struct Preview: View {
    @EnvironmentObject private var uiState: UIState
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            //----- TOPBAR
            PreviewTopBar()

            //----- GRID
            VStack {
                ZStack(alignment: .trailing) {
                    PreviewContent()
                    PreviewItemsHidden()
                }

                //----- DOTS LINE WIDTH
                dotsLineWidth(text: uiState.calcResult("page").outStr)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 10)
            .padding(.top, 5)
        }
        .drawingGroup()
        .background(Color(light: .white, dark: .white.opacity(0.05)))
        .cornerRadius(15)
        .overlay( colorScheme == .dark ? RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.1), lineWidth: 1) : nil)
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 2)
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 5)
    }
}

/*------------------------------------------------
---- PREVIEW TOP BAR
------------------------------------------------*/

struct PreviewTopBar: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        HStack(spacing: 0) {
            Text("Preview")
                .font(.system(size: 14, weight: .medium))
                .opacity(0.6)
            Spacer()
            Text("Px")
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .opacity(0.6)
        }
        .padding(.horizontal, 15).padding(.vertical, 10)
        .background(Color(light: .white.opacity(0), dark: .white.opacity(0.05)))
        Divider().opacity(colorScheme == .dark ? 0 : 1)
    }
}

/*------------------------------------------------
---- PREVIEW CONTENT
------------------------------------------------*/

struct PreviewContent: View {
    @EnvironmentObject private var state: UIState

    var body: some View {
        HStack(spacing: 0) {
            marginWidthOut(params: state.params, position: "left")
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(state.params.columnItems, id: \.id) { i in
                        ItemGrid(id: i.number)
                    }
                }
                .frame(minWidth: 0, maxWidth: geometry.size.width, alignment: .leading)
                .onChange(of: geometry.size.width) { newSize in
                    state.params.realWidth = newSize;
                }
            }
            marginWidthOut(params: state.params, position: "right")
        }
        .frame(height: 140)
    }
}

/*------------------------------------------------
---- PREVIEW ITEMS HIDDEN
------------------------------------------------*/

struct PreviewItemsHidden: View {
    @EnvironmentObject private var state: UIState

    var body: some View {
        if (state.countItems() >= 14 && state.params.columnItemsHidden != 0) {
            Text(String("+\(state.params.columnItemsHidden)"))
                .padding(5)
                .foregroundColor(.white)
                .font(.system(size: state.params.columnItems.count > 10 ? 12 : 15, weight: .bold, design: .monospaced))
                .background(LinearGradient(gradient: Gradient(colors: [tColor.main, tColor.second]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(6)
                .shadow(color: Color(red: CGFloat(0.0/255.0), green: CGFloat(62.0/255.0), blue: CGFloat(138.0/255.0)).opacity(0.2), radius: 3, x: 0, y: 2)
                .shadow(color: Color(red: CGFloat(0.0/255.0), green: CGFloat(26.0/255.0), blue: CGFloat(104.0/255.0)).opacity(0.2), radius: 8, x: 0, y: 7)
                .offset(x: -10, y: 65)
        }
    }
}
