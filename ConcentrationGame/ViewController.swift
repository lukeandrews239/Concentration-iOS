//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Luke Andrews on 6/28/18.
//  Copyright © 2018 Luke Andrews. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)

    @IBOutlet weak var NewGameButton: UIButton!
    @IBOutlet weak var scoreCountLabel: UILabel!
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!

    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            if game.didWin() {
                game.resetApp(count: (cardButtons.count + 1) / 2)
                updateViewFromModel()
                emojiChoices = game.emojiKey()
            }
        } else {
            print("Card not Connected!")
        }
    }

    @IBAction func resetApp(_ sender: UIButton) {
        game.resetApp(count: (cardButtons.count + 1) / 2)
        updateViewFromModel()
        emojiChoices = game.emojiKey()
    }

    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.722501644, green: 0.953036127, blue: 1, alpha: 1)
            }
            flipCountLabel.text = "Flips: \(game.flipCount)"
            scoreCountLabel.text = "Score: \(game.score)"
        }
    }

    var emojiChoices = [String]()
    var emoji = [Int:String]()

    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil {
            if emojiChoices.isEmpty {
                emojiChoices = game.emojiKey()
            }
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier]!
    }
}


















