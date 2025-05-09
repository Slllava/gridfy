//
//  OptionsUI.swift
//  Gridfy
//
//  Created by Viacheslav Kharkov on 03.03.2023.
//

import SwiftUI

/*------------------------------------------------
---- OPTIONS
------------------------------------------------*/

struct OptionsView: View {
    @StateObject private var params = UIState()
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @StateObject private var dataOpt = DataUserDefaults()
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        VStack(spacing: 20) {
            
            //----- APPEARANCE
            HStack {
                Text("Appearance:")
                Spacer()
                Picker(selection: $params.appearance, label: Text("Appearance")) {
                    Image(systemName: "gearshape").tag(ColoringScheme.auto)
                    Image(systemName: "sun.min").tag(ColoringScheme.light)
                    Image(systemName: "moon").tag(ColoringScheme.dark)
                }
                .pickerStyle(SegmentedPickerStyle())
                .scaledToFit()
            }
            
            //----- ANIMATION
            Form {
                HStack {
                    Text("Animation:").font(.system(size: 13, weight: .regular))
                    Spacer()
                    Toggle("Enable", isOn: $params.animation)
                }
            }

            //----- COLOR THEME OR BUY PLUS VERSION
            if purchaseManager.hasUnlockedPlus {
                Form {
                    HStack {
                        Text("Color Theme:").font(.system(size: 13, weight: .regular))
                        Spacer()
                        CustomColorPicker(selectedColor: $params.colorTheme)
                    }
                }
            } else {
                Form {
                    HStack {
                        Text("Plus Version:").font(.system(size: 13, weight: .regular))
                        Spacer()
                        Button(action: { openWindow(id: "plusPurchase") }, label: {
                            Text("Unlock")
                        })
                    }
                }
            }
        }
    }
}

/*------------------------------------------------
---- THEME COLOR PICKER
------------------------------------------------*/

struct CustomColorPicker: View {
    @Binding var selectedColor: ColoringTheme
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 10) {
            ForEach(ColoringTheme.allCases, id: \.self) { color in
                Button(action: {
                    self.selectedColor = color
                    print(self.selectedColor)
                }) {
                    Rectangle()
                        .fill(color.scheme)
                        .frame(width: 15, height: 15)
                        .cornerRadius(50)
                        .overlay(RoundedRectangle(cornerRadius: 50).strokeBorder(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.2), lineWidth: self.selectedColor == color ? 2 : 0))
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
}

/*------------------------------------------------
---- FOOTER OPTIONS
------------------------------------------------*/

struct FooterOptionsView: View {
    let appVersion = Bundle.main.releaseVersionNumberPretty
    let appName = Bundle.main.NameAppPretty

    var body: some View {
        HStack {
            HStack {
                Text(appName)
                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                    .opacity(0.6)
                Text(appVersion)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .opacity(0.5)
                    .padding(.vertical, 3).padding(.horizontal, 5)
                    .background(Color(light: .black.opacity(0.08), dark: .white.opacity(0.08)))
                    .cornerRadius(5)
            }
            Spacer()
            Text("by astroon").font(.system(size: 13, weight: .medium)).opacity(0.6)
        }
    }
}
