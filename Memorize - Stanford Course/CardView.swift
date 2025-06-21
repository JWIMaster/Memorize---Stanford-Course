//
//  CardView.swift
//  Memorize - Stanford Course
//
//  Created by JWI Master on 21/6/2025.
//

import SwiftUI

//View of a single card, creates a rounded rectangle that when tapped switches opacity with another rounded rectangle, checks to see if isCardFaceUp is true. Now properties are grabbedf from our card type which we defined inside our model
struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }

    
    var body: some View {
        TimelineView(.animation) { timeline in
            Pie(endAngle: .degrees(card.bonusPercentRemaining * 360)).opacity(Constants.Pie.opacity).overlay(
                Text(card.contentOfCard).font(.system(size: Constants.FontSize.largest))
                    .minimumScaleFactor(Constants.FontSize.scaleFactor)
                    .aspectRatio(1, contentMode: .fit)
                    .multilineTextAlignment(.center)
                    .padding(Constants.Pie.inset)
                    .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                    .animation(.spin(duration: 1), value: card.isMatched)
            )
            .padding(Constants.inset)
            .cardify(isCardFaceUp: card.isCardFaceUp)
            .opacity(card.isCardFaceUp || !card.isMatched ? 1 : 0)
        }
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
        static let inset: CGFloat = 5
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest/largest
        }
        struct Pie {
            static let opacity: CGFloat = 0.4
            static let inset: CGFloat = 5
        }
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        return .linear(duration: 1).repeatForever(autoreverses: false)
    }
}


#Preview {
    HStack {
        CardView(MemoryGame<String>.Card(id: "test1", contentOfCard: "x")).padding().foregroundStyle(.green)
        CardView(MemoryGame<String>.Card(id: "test1", isCardFaceUp: true, contentOfCard: "x")).padding().foregroundStyle(.green)
    }
}
