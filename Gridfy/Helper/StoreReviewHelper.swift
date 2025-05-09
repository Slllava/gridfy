//
//  StoreReviewHelper.swift
//  Gridfy
//
//  Created by Viacheslav Kharkov on 13.04.2023.
//

import SwiftUI
import StoreKit

enum ReviewRequest {
    @AppStorage("version") static var version = ""

    static func showReview() {
        let defaults = UIState()

        defaults.runsSinceLastRequest += 1
        let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let currentVersion = "Version \(appVersion), build \(appBuild)"
        
        if currentVersion != version {
            defaults.runsSinceLastRequest = 0
            version = currentVersion
        }
        
        switch defaults.runsSinceLastRequest {
        case 5, 30:
            SKStoreReviewController.requestReview()
        case _ where defaults.runsSinceLastRequest % 100 == 0:
            SKStoreReviewController.requestReview()
        default:
            break
        }
    }
}
