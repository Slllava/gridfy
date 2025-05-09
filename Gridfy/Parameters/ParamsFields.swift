//
//  ParamsFields.swift
//  Gridfy
//
//  Created by Slava on 01.05.2022.
//

import SwiftUI

/*------------------------------------------------
---- PARAMETERS FIELD
------------------------------------------------*/

struct ParamsField: View {
    let placeholder: String
    let max: Int
    let counter: Int
    @Binding var valueParams: Int
    
    init(_ placeholder: String, valueParams: Binding<Int>, max: Int = 0, counter: Int = 0) {
        self.placeholder = placeholder
        _valueParams = valueParams
        self.max = max
        self.counter = counter
    }
    
    var body: some View {
        ParamBox(placeholder) {
            Field("0", value: $valueParams, max: max)
        }
    }
}

/*------------------------------------------------
---- RESULT FIELD
------------------------------------------------*/

struct ResultField<Content>: View where Content: View  {
    let placeholder: String
    let content: () -> Content
    
    init(_ placeholder: String, @ViewBuilder content: @escaping () -> Content) {
        self.placeholder = placeholder
        self.content = content
    }

    var body: some View {
        ParamBox(placeholder) {
            content()
                .frame(height: 35)
                .font(.system(size: 20, weight: .semibold, design: .monospaced))
        }
    }
}

/*------------------------------------------------
---- PARAMETER BOX
------------------------------------------------*/

struct ParamBox<Content>: View where Content: View  {
    let placeholder: String
    let content: () -> Content
    @Environment(\.colorScheme) private var colorScheme
    
    init(_ placeholder: String, @ViewBuilder content: @escaping () -> Content) {
        self.placeholder = placeholder
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(placeholder)
                .font(.system(size: 14, weight: .regular))
                .opacity(0.5)
            HStack {
                content()
            }
        }
        .padding(.vertical, 15).padding(.horizontal, 15)
        .frame(width: 150, alignment: .leading)
        .background(Color(light: .white, dark: .white.opacity(0.05)))
        .cornerRadius(12)
        .overlay( colorScheme == .dark ? RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.1), lineWidth: 1) : nil)
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 2)
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 5)
    }
}
