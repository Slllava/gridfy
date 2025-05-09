//
//  GridfyApp.swift
//  Gridfy
//
//  Created by Slava on 26.04.2022.
//

import SwiftUI

@main
struct GridfyApp: App {
    @StateObject private var params = UIState()
    @StateObject private var purchaseManager = PurchaseManager()
    @Environment(\.colorScheme) private var colorScheme

    var body: some Scene {

        /*------------------------------------------------
        ---- MAIN WONDOW
        ------------------------------------------------*/
        WindowGroup("") {
            ContentView()
                .frame(width: 800, height: 535)
                .background(Color("Bg"))
                .environmentObject(params)
                .environmentObject(purchaseManager)
                .task { await purchaseManager.updatePurchasedProducts() }
                .onAppear(perform: {
                    print(purchaseManager.hasUnlockedPlus)
                    if(params.appearance == .light) {
                        NSApp.appearance = NSAppearance(named: .aqua)
                    } else if (params.appearance == .dark) {
                        NSApp.appearance = NSAppearance(named: .darkAqua)
                    } else {
                        NSApp.appearance = nil
                    }
                    if(params.colorTheme == .purple) {
                        NSApp.applicationIconImage = NSImage(named:"AppIconPurple")
                    } else if(params.colorTheme == .red) {
                        NSApp.applicationIconImage = NSImage(named:"AppIconRed")
                    } else if(params.colorTheme == .yellow) {
                        NSApp.applicationIconImage = NSImage(named:"AppIconYellow")
                    } else if(params.colorTheme == .green) {
                        NSApp.applicationIconImage = NSImage(named:"AppIconGreen")
                    } else {
                        NSApp.applicationIconImage = nil
                    }
                    ReviewRequest.showReview()
                })
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowToolbarStyle(UnifiedWindowToolbarStyle())
        .windowResizabilityContentSize()
        
        /*------------------------------------------------
        ---- SETTINGS WINDOW
        ------------------------------------------------*/
        Window("", id: "settings") {
            SettingsView()
                .environmentObject(purchaseManager)
                .frame(width: 500, height: 250)
                .background(VisualEffectView().ignoresSafeArea())
        }
        .windowResizabilityContentSize()
        .windowStyle(HiddenTitleBarWindowStyle())
        
        /*------------------------------------------------
        ---- PLUS PURCHASE WINDOW
        ------------------------------------------------*/
        Window("", id: "plusPurchase") {
            PlusPurchaseView()
                .environmentObject(purchaseManager)
                .frame(width: 550, height: 270, alignment: .center)
                .offset(y: -10)
                .background(VisualEffectView().ignoresSafeArea())
        }
        .windowResizabilityContentSize()
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
