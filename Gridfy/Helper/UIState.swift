//
//  UIState.swift
//  Gridfy
//
//  Created by Slava on 21.05.2022.
//

import Foundation
import SwiftUI

/*------------------------------------------------
---- UISTATE
------------------------------------------------*/

class UIState: ObservableObject {
    //----- PARAMETERS
    @Published var params = Parameters()
    
    //----- ADDITIONAL VARIABLES
    @Published var resetParam: Bool = false
    @Published var updateCount: Int = 0
    @Published var addedCount: Int = 0
    @Published var typeResult: typeResult = .page
    @Published var errorInfo = ErrorInfo(name: "ok", description: "Everything is perfect!")
    @Published var startCaunter = false
    
    //----- SETTINGS
    @AppStorage("colorTheme") var colorTheme: ColoringTheme = .blue {
        didSet {
            switch colorTheme {
                case .purple:
                    NSApp.applicationIconImage = NSImage(named:"AppIconPurple")
                case .red:
                    NSApp.applicationIconImage = NSImage(named:"AppIconRed")
                case .yellow:
                    NSApp.applicationIconImage = NSImage(named:"AppIconYellow")
                case .green:
                    NSApp.applicationIconImage = NSImage(named:"AppIconGreen")
                default:
                    NSApp.applicationIconImage = nil
            }
        }
    }
    @AppStorage("runsSinceLastRequest") var runsSinceLastRequest: Int = 0
    @AppStorage("animation") var animation: Bool = true
    @AppStorage("appearance") var appearance: ColoringScheme = .auto {
        didSet {
            switch appearance {
            case .light:
                NSApp.appearance = NSAppearance(named: .aqua)
            case .dark:
                NSApp.appearance = NSAppearance(named: .darkAqua)
            default:
                NSApp.appearance = nil
            }
        }
    }

    //----- INIT
    init() { addColumns(10, false) }
    
    //----- SET ERROR
    func setError(_ val: Bool, _ description: String) {
        if val == false {
            errorInfo = ErrorInfo(name: "error", description: description)
        } else {
            if(errorInfo.name == "error" && description == errorInfo.description) {
                errorInfo = ErrorInfo(name: "ok", description: "Everything is perfect!")
            }
        }
    }
    
    //----- COUNT ITEMS
    func countItems() -> Int {
        return params.columnItems.count + params.columnItemsHidden
    }

    //----- RESET
    func reset() {
        params = Parameters()
        addColumns(10, false)
        resetParam = true
    }

    //----- REMOVE ALL COLUMNS
    func removeAllColumns() {
        params.columnItems.removeAll()
    }

    //----- REMOVE LAST COLUMN
    func removeLastColumn() {
        if params.columnItems.count <= 14 && params.columnItemsHidden <= 0 {
            params.columnItems.removeLast()
            params.columnItemsHidden = 0
        } else {
            params.columnItemsHidden -= 1
        }
    }

    //----- ADD COLUMN
    func addColumn(_ updateCountRender: Bool = true) {
        if params.columnItems.count < 14 {
            params.columnItems.append(ColumnItem(number: params.columnItems.count + 1, width: 0))
            params.columnItemsHidden = 0
        } else {
            params.columnItemsHidden += 1
        }
    }

    //----- ADD COLUMNS
    func addColumns(_ count:Int = 1, _ updateCountRender:Bool = true) {
        for _ in 1...count {
            addColumn(updateCountRender)
        }
    }

    //----- CALCULATE RESULT
    func calcResult(_ type: String, widthPage: CGFloat = 0.0) -> (out: Float, outStr: String, isInt: Bool, isMinus: Bool) {
        let params = params
        let columCount = Float(countItems())
        let varResult = typeResult
        let gutterWidth = params.gutterWidth == -1 ? 0 : params.gutterWidth
        let marginWidth = params.marginWidth == -1 ? 0 : params.marginWidth
        //  Coulumn & Width
        var dotColum = Float(0)
        if(widthPage == 0.0) {
            dotColum = (Float(params.maxWidth) - (Float(marginWidth) * 2) - (Float(gutterWidth) * (columCount - 1))) / columCount
        } else {
            dotColum = (Float(widthPage) - (Float(marginWidth) * 2) - (Float(gutterWidth) * (columCount - 1))) / columCount
        }
        let Column = varResult == .column ? dotColum : Float(Int(dotColum))
        let dotWidth = Float(params.maxWidth) - ((dotColum - Column) * columCount)
        let Width = varResult == .column ? Float(params.maxWidth) : dotWidth
        
        let type = type == "column" ? Column : Width
        
        let isInt = floor(type) == type
        let isMinus = dotColum > 0
        let out = type
        let outStr = String(format: isInt ? "%.0f" : "%.1f", type)
        return (out, outStr, isInt, isMinus)
    }
}

/*------------------------------------------------
---- COLUMN ITEM
------------------------------------------------*/

struct ColumnItem {
    let id = UUID()
    let number: Int
    let width: Int
}

/*------------------------------------------------
---- PARAMETERS
------------------------------------------------*/

struct Parameters {
    var columnItems = [ColumnItem]()
    var columnItemsNum = 10
    var columnItemsHidden = 0
    var gutterWidth: Int = 10
    var marginWidth: Int = 20
    var maxWidth: Int = 920
    var realWidth: CGFloat = 920
}

/*------------------------------------------------
---- ERROR INFO
------------------------------------------------*/

struct ErrorInfo {
    let id = UUID()
    let name: String
    let description: String
}

/*------------------------------------------------
---- COLORING SCHEME / ENUM
------------------------------------------------*/

enum ColoringTheme: Int, CaseIterable {
    case blue, purple, red, yellow, green
    var scheme: Color {
        switch self {
        case .blue:
            return .blue
        case .purple:
            return .purple
        case .red:
            return .red
        case .yellow:
            return .yellow
        case .green:
            return .green
        }
    }
}

enum ColoringScheme: Int, CaseIterable {
    case auto, light, dark
    
    init(rawValue: Int) {
        switch rawValue {
        case 1: self = .light
        case 2: self = .dark
        default:
            self = .auto
        }
    }
    
    var text: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        case .auto:
            return "Auto"
        }
    }
    
    var scheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .auto:
            return nil
        }
    }
}

/*------------------------------------------------
---- COLORING THEME
------------------------------------------------*/

struct tColor {
    static var main: Color {
        let state = UIState()
        if state.colorTheme == .purple {
            return Color("MainPurple")
        } else if state.colorTheme == .red {
            return Color("MainRed")
        } else if state.colorTheme == .yellow {
            return Color("MainYellow")
        } else if state.colorTheme == .green {
            return Color("MainGreen")
        } else {
            return Color("MainBlue")
        }
    }
    static var second: Color {
        let state = UIState()
        if state.colorTheme == .purple {
            return Color("SecondPurple")
        } else if state.colorTheme == .red {
            return Color("SecondRed")
        } else if state.colorTheme == .yellow {
            return Color("SecondYellow")
        } else if state.colorTheme == .green {
            return Color("SecondGreen")
        } else {
            return Color("SecondBlue")
        }
    }
    static var dark: Color {
        let state = UIState()
        if state.colorTheme == .purple {
            return Color("DarkPurple")
        } else if state.colorTheme == .red {
            return Color("DarkRed")
        } else if state.colorTheme == .yellow {
            return Color("DarkYellow")
        } else if state.colorTheme == .green {
            return Color("DarkGreen")
        } else {
            return Color("DarkBlue")
        }
    }
    static var ultraDark: Color {
        let state = UIState()
        if state.colorTheme == .purple {
            return Color("UltraDarkPurple")
        } else if state.colorTheme == .red {
            return Color("UltraDarkRed")
        } else if state.colorTheme == .yellow {
            return Color("UltraDarkYellow")
        } else if state.colorTheme == .green {
            return Color("UltraDarkGreen")
        } else {
            return Color("UltraDarkBlue")
        }
    }
}

/*------------------------------------------------
---- TYPE RESUSLT
------------------------------------------------*/

enum typeResult {
    case page
    case column
}
