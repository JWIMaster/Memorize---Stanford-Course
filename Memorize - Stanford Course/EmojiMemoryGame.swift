//
//  EmojiMemoryGame.swift
//  Memorize - Stanford Course
//
//  Created by JWI Master on 18/6/2025.
//

//This is a ViewModel. The ViewModel's job is to essentially create a public class that the View accesses, and said class is essentially a copy of the struct we created in the Model, that is, an instance of it.

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    private static let emojis = ["👻", "🎃", "🦇","🧛","⚰️","🪄","🔮","🧿","🦄","🍭","🧙","🧌"]
    
    //This function creates a memory game. The function asks to return an object of type MemoryGame, which we defined in our model's struct
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairsOfCards: 8, cardContentFactory: { pairIndex in
            return emojis[pairIndex]
        }
        )
    }
    //Publishing this makes it observable so we can update our ui. This variable basically creates an instance of our createMemoryGame func, which in turn creates an instance of our MemoryGame struct, in other words, a MemoryGame, with in this case a name of model.
    @Published private var model = createMemoryGame()
    
    
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    var score: Int {
        model.score
    }
    //MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
