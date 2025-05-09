//
//  ContentUI.swift
//  Gridfy
//
//  Created by Slava on 23.05.2022.
//

import SwiftUI

/*------------------------------------------------
---- TITLE APP
------------------------------------------------*/

struct TitleBar: View {
    @Environment(\.openWindow) var openWindow
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @Environment(\.colorScheme) private var colorScheme
    let appName = Bundle.main.NameAppPretty

    var body: some View {
        HStack() {}.toolbar {
            ToolbarItem(placement: .status) {
                HStack {
                    Text(appName).font(.system(size: 14, weight: .semibold))
                    //----- IF PLUS
                    if purchaseManager.hasUnlockedPlus {
                        Text("Plus").font(.system(size: 10, weight: .semibold))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 5)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(colorScheme == .dark ?  .white.opacity(0.15) : .black.opacity(0.15), lineWidth: 1))
                    }
                }
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Spacer()
                Button(action: { openWindow(id: "settings") }, label: {Image(systemName: "gear") })
            }
        }
    }
}

/*------------------------------------------------
---- FOOTER APP
------------------------------------------------*/

struct FooterApp: View {
    @EnvironmentObject private var uiState: UIState
    @Environment(\.openURL) var openURL
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 10) {
                Circle()
                    .fill(uiState.errorInfo.name == "ok" ? .green : .red)
                    .frame(width: 6, height: 6)
                Text(uiState.errorInfo.description)
            }
            Spacer()
            Button(action: {
                openURL(URL(string: "https://apps.apple.com/app/id1671263220?action=write-review")!)
            }, label: {Image(systemName: "star.fill") })
            .buttonStyle(PlainButtonStyle())
            .opacity(0.5)
            
        }
        .padding(15)
        .padding(.horizontal, 15)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .background(VisualEffectView())
    }
}
