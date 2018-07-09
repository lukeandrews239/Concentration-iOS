//
//  Concentration.swift
//  ConcentrationGame
//
//  Created by Luke Andrews on 6/28/18.
//  Copyright © 2018 Luke Andrews. All rights reserved.
//

import Foundation

class Concentration
{
    // MARK: - Public Properties

    private (set) var cards = [Card]()
    var score = 0
    var flipCount = 0

    // MARK: - Private Properties

    private var indexOfSingleCard: Int?
    private let themes: [Int:[String]] = [
        0:["👌","🤘","👊","🖖","🤙","👍","👏","✌️"],
        1:["⚽️","🏀","🏈","⚾️","🎾","🏐","🏉","🎱"],
        2:["🙄","😶","😂","😩","😎","😜","🤩","😍"],
        3:["🐶","🙈","🐸","🐼","🦁","🙉","🐯","🐻"],
        4:["🍏","🍎","🍑","🍒","🍍","🌶","🍓","🍆"],
        5:["🚗","🚙","🏍","🚌","🏎","🚑","🚓","🚒"],
    ]

    // MARK: - Init

    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        shuffleDeck()
    }

    // MARK: - Public

    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfSingleCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    checkScore(first: index, second: matchIndex)
                }
                cards[index].isFaceUp = true
                indexOfSingleCard = nil
            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfSingleCard = index
            }
            flipCount += 1
        }
    }

    func didWin() -> Bool{
        for card in cards {
            if card.isMatched == false {
                return false
            }
        }
        return true
    }

    func emojiKey() -> [String] {
        let randomTheme = Int(arc4random_uniform(UInt32(6)))
        return themes[randomTheme]!
    }

    func resetApp(count reset: Int) {
        cards.removeAll()
        flipCount = 0
        score = 0
        for _ in 0..<reset {
            let card = Card()
            cards += [card, card]
        }
        shuffleDeck()
    }
}


// MARK: - Private

private extension Concentration {

    func shuffleDeck() {
        var newArray = [Card]()
        for _ in cards.indices {
            let randomCard = Int(arc4random_uniform(UInt32(cards.count)))
            newArray.append(cards.remove(at: randomCard))
        }
        cards = newArray
    }

    func checkScore(first: Int, second: Int) {
        if !cards[second].isMatched && !cards[first].isMatched {
            if cards[second].hasFlipped {
                score -= 1
            }
            if cards[first].hasFlipped {
                score -= 1
            }
            cards[second].hasFlipped = true
            cards[first].hasFlipped = true
        }
    }
}
