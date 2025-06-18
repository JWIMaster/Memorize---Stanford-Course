//
//  ContentView.swift
//  Memorize - Stanford Course
//
//  Created by JWI Master on 18/6/2025.
//

import SwiftUI
//Main ContentView
struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    //Contains all other views
    var body: some View {
        
        VStack {
            ScrollView {
                cards
            } //Allows this portion to be scrollable
            Button("Shuffle") {
                viewModel.shuffle()
            }
        }.padding() //IMPORTANT!! SWIFTUI BUGS OUT WHEN BUTTONS AND INTERACTABLES ARE TOUCHING THE BOTTOM AND TOP OF THE SCREEN
    }
    
    //Card creation controller
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum:120), spacing: 0)]) { //[GridItem()] is proper notation here, LazyVGrid spaces the cards, adaptive minimum tells the grid how small these cards can be
            ForEach(viewModel.cards.indices, id: \.self) { index in //Must use this notation, spawns a card in from 1 till cardcount, ie cardcount many cards
                CardView(card: viewModel.cards[index]).aspectRatio(2/3, contentMode: .fit).padding(4) // from our declared viewModel which grabs from Model, we can grab the array of cards and see what the index of any give card is
            }
        }.foregroundStyle(.blue)
    }
}

//View of a single card, creates a rounded rectangle that when tapped switches opacity with another rounded rectangle, checks to see if isCardFaceUp is true. Now properties are grabbedf from our card type which we defined inside our model
struct CardView: View {
    let card: MemoryGame<String>.Card
    var body: some View {
        ZStack {
            let baseCard = RoundedRectangle(cornerRadius: 12)
            Group {
                baseCard.foregroundStyle(.white)
                baseCard.strokeBorder(lineWidth: 2)
                Text(card.contentOfCard).font(.system(size: 200)).minimumScaleFactor(0.01).aspectRatio(1, contentMode: .fit)
            }.opacity(card.isCardFaceUp ? 1 : 0)
            baseCard.fill().opacity(card.isCardFaceUp ? 0 : 1)
        }
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
