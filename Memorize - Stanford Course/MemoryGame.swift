//
//  Memorize_Game.swift
//  Memorize - Stanford Course
//
//  Created by JWI Master on 18/6/2025.
//

//This is our model. Our model runs all the actual code itself. We pass this into our ViewModel which is an instance of this code

import Foundation


struct MemoryGame<CardContent> where CardContent: Equatable {
    

    private(set) var cards: [Card]
    
    private(set) var score: Int = 0
    

    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent ) {
        cards = [Card]()

        for pairIndex in 0..<numberOfPairsOfCards {
            let content: CardContent = cardContentFactory(pairIndex)
            cards.append(Card(id: "\(pairIndex+1)a", contentOfCard: content))
            cards.append(Card(id: "\(pairIndex+1)b", contentOfCard: content))
        }
    }
    
    //TODO: Understand this logic too
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { index in cards[index].isCardFaceUp }.only
        }
        set {
            return cards.indices.forEach { cards[$0].isCardFaceUp = (newValue == $0) }
        }
    }
    
    //TODO: Understand this game logic
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isCardFaceUp && !cards[chosenIndex].isMatched{
                if let possibleMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].contentOfCard == cards[possibleMatchIndex].contentOfCard {
                        cards[chosenIndex].isMatched = true
                        cards[possibleMatchIndex].isMatched = true
                        score += 2 + cards[chosenIndex].bonus + cards[possibleMatchIndex].bonus
                    } else {
                        if cards[chosenIndex].hasBeenSeen {
                            score -= 1
                        }
                        if cards[possibleMatchIndex].hasBeenSeen {
                            score -= 1
                        }
                    }
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                
                cards[chosenIndex].isCardFaceUp = true
            }
        }
        
    }

    mutating func shuffle() {
        cards.shuffle()
    }
    
    

    struct Card: Equatable, Identifiable {
        var id: String
        
        var isCardFaceUp: Bool = false {
            didSet {
                if isCardFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                if oldValue && !isCardFaceUp {
                    hasBeenSeen = true
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        var hasBeenSeen: Bool = false
        let contentOfCard: CardContent
        
        
        // MARK: - Bonus Time
        
        // call this when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isCardFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // call this when the card goes back face down or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        // the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
        // this gets smaller and smaller the longer the card remains face up without being matched
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        // percentage of the bonus time remaining
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }
        
        // how long this card has ever been face up and unmatched during its lifetime
        // basically, pastFaceUpTime + time since lastFaceUpDate
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // can be zero which would mean "no bonus available" for matching this card quickly
        var bonusTimeLimit: TimeInterval = 6
        
        // the last time this card was turned face up
        var lastFaceUpDate: Date?
        
        // the accumulated time this card was face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
    }
}


//OUR FIRST SWIFT EXTENSION. okay so basically this just extends the functionality of a given type
extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
