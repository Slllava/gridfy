//
//  UIStateFunc.swift
//  Gridfy
//
//  Created by Slava on 21.05.2022.
//

import Foundation
import SwiftUI

extension UIState {
    
    func countBinding(_ i: Int) -> Void {
        let defaults = DataUserDefaults()
        let count = countItems()
        var countAdded = count == 0 ? i : 0
        let items = i <= 0 ? -1 : i
    
        //----- COUNT ADDED
        if i > count {
            countAdded = i - count
        } else {
            countAdded = count - i
        }
        addedCount = countAdded
        
        //----- IF ERROR
        guard items > 0 || i > 0 else { return }
        
        //----- If 5
        if i <= 5 || countAdded >= 3 && items <= 14 {
            params.columnItems.removeAll()
            for _ in 1...items { addColumn() }
        }
        //----- If 14
        else if items > 14 {
            if i > countItems() {
                    for _ in 1...countAdded {
                        addColumn()
                    }
                }
            else if i < countItems() {
                    for _ in 1...countAdded {
                        removeLastColumn()
                    }
                }
        }
        //----- If > 5 AND < 14
        else {
            if i > countItems() {
                for _ in 1...countAdded {
                    withAnimation(defaults.animateOn() ? Animation.interpolatingSpring(mass: 0.04, stiffness: 5.0, damping: 0.7, initialVelocity: 8.0) : Animation.linear(duration: 0)) { () -> () in
                        addColumn()
                    }
                }
            } else if i < countItems() {
                withAnimation(defaults.animateOn() ? Animation.interpolatingSpring(mass: 0.04, stiffness: 5.0, damping: 0.7, initialVelocity: 8.0) : Animation.linear(duration: 0)) { () -> () in
                    for _ in 1...countAdded {
                        removeLastColumn()
                    }
                }
            }
        }
        //----- UPDATE COUNT
        updateCount += 1
    }
}
