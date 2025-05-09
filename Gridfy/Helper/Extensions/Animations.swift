//
//  Animations.swift
//  Gridfy
//
//  Created by Slava on 21.05.2022.
//
import SwiftUI

extension AnyTransition {
    static func itemAny(_ itemID: Int = 0, _ state: UIState)  -> AnyTransition {
    let insertion = AnyTransition.scale(scale: 1.2, anchor: .center)
            .combined(with: .opacity).animation(Animation.interpolatingSpring(mass: 0.04, stiffness: 10.0, damping: 0.7, initialVelocity: 8.0)
            )
        let removal = AnyTransition.scale(scale: 0, anchor: .center).animation(.none)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
