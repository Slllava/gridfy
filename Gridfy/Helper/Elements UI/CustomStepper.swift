//
//  CustomStepper.swift
//  Gridfy
//
//  Created by Slava on 01.05.2022.
//

import SwiftUI

/*------------------------------------------------
---- STEPPER
------------------------------------------------*/

struct CustomStepper : View {
    @Binding var value: Int
    var max: Int
    var focused: FocusState<Bool>.Binding
    @State var isPressed = false

    var body: some View {
        VStack(spacing: 1) {
            ButtonStapper(value: $value, max: max, focused: focused, act: "plus")
            ButtonStapper(value: $value, max: max, focused: focused, act: "minus")
        }
    }
}

/*------------------------------------------------
---- BUTTON STEPPER
------------------------------------------------*/

struct ButtonStapper: View {
    @Binding var value: Int
    var max: Int
    var focused: FocusState<Bool>.Binding
    let act: String
    @FocusedBinding(\.valBinding) var val
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: {
            focused.wrappedValue = true
            if act == "plus" && (self.max == 0 || self.value < self.max) {
                self.value += 1
            } else if  act == "minus" && self.value > 0 {
                self.value -= 1
            }
            self.performHapticFeedback()
        }, label: {
            Image(systemName: act == "plus" ? "chevron.up" : "chevron.down")
                .font(.system(size: 10))
                .padding(.horizontal, 20)
                .foregroundColor(focused.wrappedValue ? .white : Color(light: .black.opacity(0.8), dark: .white))
                .frame(width: 24, height: 14)
                .background(RoundedCorners(color: focused.wrappedValue ? tColor.dark : Color(light: .white, dark: .white.opacity(0.25)), tl: act == "plus" ? 3 : 0, tr: act == "plus" ? 3 : 0, bl: act == "plus" ? 0 : 3, br: act == "plus" ? 0 : 3))
                .shadow(color: .black.opacity(colorScheme == .dark || focused.wrappedValue ? 0 : 0.15), radius: 1, x: 0, y: 0.5)
        })
        .buttonStyle(PlainButtonStyle())
    }

    // ----- HAPTIC FEEDBACK
    func performHapticFeedback() {
         NSHapticFeedbackManager.defaultPerformer.perform(
             NSHapticFeedbackManager.FeedbackPattern.generic,
             performanceTime: NSHapticFeedbackManager.PerformanceTime.now
         )
    }
}
