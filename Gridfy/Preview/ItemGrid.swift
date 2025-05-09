//
//  ItemGrid.swift
//  Gridfy
//
//  Created by Slava on 01.05.2022.
//

import SwiftUI

struct ItemGrid: View {
    let id: Int
    @EnvironmentObject private var state: UIState
    @State var animateTrigger = false
    var defaults = DataUserDefaults()
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                //----- LIGHT EFFECT
                Rectangle()
                    .fill(.white)
                    .frame(width: 1000, height: 50)
                    .blur(radius: 20, opaque: false)
                    .opacity(0.3)
                    .offset(x: 0, y: (animateTrigger || !defaults.animateOn()) && state.updateCount >= 1 ? 200 : -200)
                    .transition(.opacity)
                //----- COLUMN SIZE
                ColumnSizeView()
            }
        }
        .frame(minWidth: 0, maxWidth: maxWidthFunc(id: id, widthMain: state.params.realWidth), minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: [tColor.main, tColor.second]), startPoint: .top, endPoint: .bottom))
        .overlay(animateTrigger || !defaults.animateOn() ? Rectangle().stroke(Color.white.opacity(0.3), lineWidth: 5).blur(radius: 3) : nil)
        .animation(Animation.easeInOut(duration: 2), value: animateTrigger && defaults.animateOn())
        .cornerRadius(6)
        .shadow(color: tColor.main.opacity(colorScheme == .dark ? 0 : 0.23), radius: 10, x: 0, y: 10)
        .shadow(color: tColor.second.opacity(colorScheme == .dark ? 0 : 0.23), radius: 4, x: 0, y: 2)
        .transition(defaults.animateOn() ? .itemAny(id, state) : .identity)
        .onAppear() { animateTrigger.toggle() }

        //----- GUTTER SIZE
        GutterView(id: id)
    }

    //----- MAX WIDTH FUNCTION
    func maxWidthFunc(id: Int, widthMain: CGFloat) -> CGFloat {
        var out = 0.0;
        let columns = state.countItems() > 14 ? 14 : state.countItems()
        if (columns != 1) {
            out = (widthMain / CGFloat(columns))
        } else { out = .infinity }
        return out;
    }
}

/*------------------------------------------------
---- COLUMN SIZE VIEW
------------------------------------------------*/

struct ColumnSizeView: View {
    @EnvironmentObject private var state: UIState
    @Environment(\.colorScheme) private var colorScheme
    @State var animateTrigger = false
    var defaults = DataUserDefaults()

    var body: some View {
        let params = state.params
        Group {
            Text(state.calcResult("column").outStr)
                .font(.system(size: params.columnItems.count > 10 ? 12 : 15, weight: .semibold, design: .monospaced))
                .foregroundColor(tColor.ultraDark)
        }
            .frame(height: params.columnItems.count > 10 ? 20 : 25)
            .padding(.horizontal, params.columnItems.count > 10 ? 5 : 6)
            .background(LinearGradient(gradient: Gradient(colors: [.white.opacity(1.0), tColor.second.opacity(colorScheme == .dark ? 0.4 : 0)]), startPoint: params.columnItems.count > 10 ? .trailing : .top , endPoint: params.columnItems.count > 10 ? .leading : .bottom))
            .background(RoundedRectangle(cornerRadius: params.columnItems.count > 10 ? 5 : 6).fill(Color.white))
            .overlay(Rectangle().stroke(Color.white, lineWidth: 2).blur(radius: 3))
            .cornerRadius(params.columnItems.count > 10 ? 5 : 6)
            .shadow(color: Color(red: CGFloat(0.0/255.0), green: CGFloat(62.0/255.0), blue: CGFloat(138.0/255.0)).opacity(0.2), radius: 3, x: params.columnItems.count > 10 ? -2 : 0, y: params.columnItems.count > 10 ? 0 : 2)
            .shadow(color: Color(red: CGFloat(0.0/255.0), green: CGFloat(26.0/255.0), blue: CGFloat(104.0/255.0)).opacity(0.2), radius: 8, x: params.columnItems.count > 10 ? -7 : 0, y: params.columnItems.count > 10 ? 0 : 7)
            .scaleEffect(animateTrigger || !defaults.animateOn() ? 1 : (state.updateCount > 1 ? 0.2 : 1))
            .animation(Animation.interpolatingSpring(mass: 0.02, stiffness: 7.1, damping: 0.21, initialVelocity: 9.15), value: animateTrigger && defaults.animateOn())
            .rotationEffect(params.columnItems.count > 10 ? .degrees(-90) : .degrees(0))
            .transition(.opacity)
            .onAppear() { animateTrigger.toggle() }
    }
}

/*------------------------------------------------
---- GUTTER VIEW
------------------------------------------------*/

struct GutterView: View {
    var id: Int
    @EnvironmentObject private var state: UIState
    var defaults = DataUserDefaults()

    var body: some View {
        let columns = state.params.columnItems.count > 20 ? 20 : state.params.columnItems.count

        if id != columns && id < 14 && state.params.columnItems.count != 0  {
            Group {
                Text(String(state.params.gutterWidth == -1 ? 0 : state.params.gutterWidth))
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .rotationEffect(.degrees(-90))
                    .frame(minWidth: 140)
                    .transition(defaults.animateOn() ? .itemAny(id, state) : .identity)
            }
            .frame(minWidth: gutterWidthFunc(id: id) < 20 ? 15 : 0, maxWidth: gutterWidthFunc(id: id) < 20 ? 20 : gutterWidthFunc(id: id), minHeight: 0, maxHeight: .infinity)
        }
    }
    //----- GUTTER WIDTH FUNCTION
    func gutterWidthFunc(id: Int) -> CGFloat {
        var out = 0.0;
        out = CGFloat(state.params.gutterWidth / 2)
        return out;
    }
}

/*------------------------------------------------
---- MARGIN VIEW
------------------------------------------------*/

struct marginWidthOut: View {
    let params: Parameters
    let position: String

    var body: some View {
        if(params.marginWidth > 0) {
            Group {
                Text(String(params.marginWidth))
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .frame(minWidth: 140)
                    .rotationEffect(.degrees(-90))
                    .opacity(0.5)
            }
            .frame(minWidth: 0, maxWidth: 20, minHeight: 0, maxHeight: .infinity)
            .padding(2)
            .background(RoundedCorners(color: Color(light: .black.opacity(0.07), dark: .white.opacity(0.05)), tl: position == "left" ? 5 : 0, tr: position == "right" ? 5 : 0, bl: position == "left" ? 5 : 0, br: position == "right" ? 5 : 0))
        }
    }
}
