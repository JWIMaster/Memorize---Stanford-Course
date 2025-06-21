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
    private let aspectRatio: CGFloat = 2/3
    //Contains all other views
    var body: some View {
        
        VStack {
            
            cards.foregroundStyle(.blue)
            
            HStack {
                score
                Spacer()
                shuffle
            }.font(.largeTitle)
            
        }.padding() //IMPORTANT!! SWIFTUI BUGS OUT WHEN BUTTONS AND INTERACTABLES ARE TOUCHING THE BOTTOM AND TOP OF THE SCREEN
    }
    
    private var score: some View {
        Text("Score: \(viewModel.score)").animation(nil)
    }
    
    private var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                viewModel.shuffle()
            }
        }
    }
    
    //Card creation controller
    private var cards: some View {
        AspectVGrid(items: viewModel.cards, aspectRatio: aspectRatio) { card in
            CardView(card)
                .padding(4)
                .overlay(FlyingNumber(number: scoreChanged(causedBy: card)))
                .zIndex(scoreChanged(causedBy: card) != 0 ? 1 : 0)
                .onTapGesture {
                    choose(card)
                }
        }
    }
    
    private func choose(_ card: MemoryGame<String>.Card) {
        withAnimation(.easeInOut) {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    private func scoreChanged(causedBy card: MemoryGame<String>.Card) -> Int {
        let (amount, causedByCardId: id) = lastScoreChange
        
        return card.id == id ? amount : 0 
    }
    
    
}



#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
