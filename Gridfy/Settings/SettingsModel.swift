//
//  SettingsModel.swift
//  Gridfy
//
//  Created by Slava on 23.06.2022.
//

import SwiftUI

/*------------------------------------------------
---- SETTINGS
------------------------------------------------*/

class DataUserDefaults: ObservableObject {
    let defaults = UIState()

    func animateOn() -> Bool {
        return defaults.animation
    }
    func appearance() -> ColoringScheme {
        return defaults.appearance
    }
}

/*------------------------------------------------
---- VERSION AND NAME
------------------------------------------------*/

extension Bundle {
    // ----- VERSION
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0")"
    }
    // ----- NAME APP
    var NameApp: String? {
        return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    }
    var NameAppPretty: String {
        return NameApp ?? ""
    }
}
