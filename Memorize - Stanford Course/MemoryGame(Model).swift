//
//  Memorize_Game.swift
//  Memorize - Stanford Course
//
//  Created by JWI Master on 18/6/2025.
//

//This is our model. Our model runs all the actual code itself. We pass this into our ViewModel which is an instance of this code

import Foundation

//Define our MemoryGame as a struct with a "don't care" type of CardContent, that is to say that you can pass any type into that position using MemoryGame<Whatever> where whatever is the type
struct MemoryGame<CardContent> {
    
    //This creates a variable that is read only, in this case our array of type Card
    private(set) var cards: [Card]
    
    //This is our Initialiser. This allows us to tell the Class function inside ViewModel what values we have to pass into any instance of this structure for it to work, in this case, how many pairs do we want, and a function that generates some kind of card content.
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent ) {
        cards = [Card]() //Copy our array of cards into our initialiser

        for pairIndex in 0..<numberOfPairsOfCards { //Iterate through our number of pairs to create a pair of each card
            let content: CardContent = cardContentFactory(pairIndex) //Since we want a pair, the content for the pair will be the same, therefore both cards will only call on the content factory once per pair of cards
            cards.append(Card(contentOfCard: content))
            cards.append(Card(contentOfCard: content))
        }
    }
    
    func choose(_ card: Card) {
        
    }
    
    
    //our function must be mutating as we are changing the array when shuffling, as in, changing the order of the array.
    mutating func shuffle() {
        cards.shuffle()
    }
    
    
    //This is where we create our type "Card". "Card" has several properties, that are all listed below as variables
    struct Card {
        var isCardFaceUp: Bool = true
        var isMatched: Bool = false
        let contentOfCard: CardContent
    }
}
