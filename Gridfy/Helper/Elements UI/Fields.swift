//
//  Fields.swift
//  Gridfy
//
//  Created by Slava on 04.06.2022.
//

import SwiftUI

/*------------------------------------------------
---- FIELD
------------------------------------------------*/

struct Field: View {
    let placeholder: String
    let max: Int
    let id = UUID()
    @Binding var value: Int
    @FocusState private var hasFocus: Bool
    
    // ----- BINDING
    var optionalIntBinding: Binding<String> {
        Binding(
            get: { $value.wrappedValue == -1 ? "" : String($value.wrappedValue) },
            set: { $value.wrappedValue = Int($0) ?? -1 }
        )
    }
    
    // ----- INIT
    init(_ placeholder: String, value: Binding<Int>, max: Int = 0) {
        self.placeholder = placeholder
        _value = value
        self.max = max
    }
    
    // ----- FIELD COLOR
    func fieldColor(focus: Color, unfocus: Color, error: Color) -> Color {
        if(max != 0 && value > max) {
            return error
        } else {
            if(hasFocus) {
                return focus
            } else {
               return unfocus
            }
        }
    }

    var body: some View {
        HStack() {
            TextField( placeholder, text: optionalIntBinding)
            CustomStepper(value: $value, max: max, focused: $hasFocus)
        }
        .focused($hasFocus)
        .focusedValue(\.valBinding, $value)
        .disableAutocorrection(true)
        .textFieldStyle(PlainTextFieldStyle())
        .frame(width: 100, height: 35)
        .padding(.leading, 10)
        .padding(.trailing, 3)
        .padding(.vertical, 0)
        .background(Color(light: .black.opacity(0.05), dark: Color("Input")))
        .cornerRadius(5)
        .font(.system(size: 16, weight: .medium, design: .monospaced))
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(fieldColor(focus: tColor.main, unfocus: Color(light: .black.opacity(0.15), dark: .white.opacity(0.2)), error: Color.red), lineWidth: 1))
        .padding(3)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(fieldColor(focus: tColor.main.opacity(0.2), unfocus: Color.white.opacity(0), error: Color.red), lineWidth: 4))
        .padding(-3)
    }
}

struct FocusedValBinding: FocusedValueKey {
    typealias Value = Binding<Int>
}

extension FocusedValues {
    var valBinding: FocusedValBinding.Value? {
        get { self[FocusedValBinding.self] }
        set { self[FocusedValBinding.self] = newValue }
    }
}
