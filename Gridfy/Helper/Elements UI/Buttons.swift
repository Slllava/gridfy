//
//  Buttons.swift
//  Gridfy
//
//  Created by Slava on 01.05.2022.
//

import SwiftUI

/*------------------------------------------------
---- BUTTON SMALL
------------------------------------------------*/

struct ButtonSmall: View {
    let action: () -> Void
    let icon: String
    let secondIcon: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action, label: {
            HStack(spacing: 0) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(light: .black.opacity(0.8), dark: .white.opacity(0.8)))
                    .frame(minWidth: 40, minHeight: 40)
                    .background(RoundedCorners(color: .white.opacity(colorScheme == .dark ? 0.18 : 1), tl: 10, tr: !secondIcon.isEmpty ? 0 : 10, bl: 10, br: !secondIcon.isEmpty ? 0 : 10))
                if(!secondIcon.isEmpty) {
                    Divider().frame(width: colorScheme == .dark ? 0 : 1).opacity(colorScheme == .dark ? 0 : 0.2)
                    Image(systemName: secondIcon)
                        .frame(minWidth: 15, minHeight: 40)
                        .font(.system(size: 9, weight: .bold))
                        .background(RoundedCorners(color: .white.opacity(colorScheme == .dark ? 0.1 : 1), tl: 0, tr: 10, bl: 0, br: 10))
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(colorScheme == .dark ? 0.15 : 0), lineWidth: 1))
            .shadow(color: .black.opacity(colorScheme == .dark ? 0 : 0.05), radius: 1, x: 0, y: 2)
            .shadow(color: .black.opacity(colorScheme == .dark ? 0 : 0.06), radius: 10, x: 0, y: 5)
        })
        .frame(height: 40)
        .buttonStyle(PlainButtonStyle())
    }
}
