//
//  Cardify.swift
//  Memorize - Stanford Course
//
//  Created by JWI Master on 21/6/2025.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
    
    init(isCardFaceUp: Bool) {
        rotation = isCardFaceUp ? 0 : 180
    }
    
    var isCardFaceUp: Bool {
        rotation < 90
    }
    
    var rotation: Double
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        
        ZStack {
            let baseCard = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            baseCard.strokeBorder(lineWidth: Constants.lineWidth).background(baseCard.fill(.white)).overlay(content).opacity(isCardFaceUp ? 1 : 0)
            baseCard.fill().opacity(isCardFaceUp ? 0 : 1)
        }
        .rotation3DEffect(.degrees(rotation), axis: (0,1,0))
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
    
}

extension View {
    func cardify(isCardFaceUp: Bool) -> some View {
        return modifier(Cardify(isCardFaceUp: isCardFaceUp))
    }
}
