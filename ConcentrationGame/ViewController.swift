//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Luke Andrews on 6/28/18.
//  Copyright © 2018 Luke Andrews. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var NewGameButton: UIButton!
    @IBOutlet weak var scoreCountLabel: UILabel!
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!

    // MARK: Private Properties

    private lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    private var emojiChoices = [String]()
    private var emoji = [Int:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Feel free to change forCity variable to other cities! (ex: "London", "Orono")
        Weather.getWeatherFromWeb(forCity: "Boston") { (result: Weather) in
            DispatchQueue.main.async {
                self.weatherLabel.text = "City: \(result.city), Temp: \(result.temp)F, Description: \(result.desc)"
            }
        }
    }
}

// MARK: - UI Actions
private extension ViewController {

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
}

// MARK: Private
private extension ViewController {
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

    func emoji(for card: Card) -> String? {
        if emoji[card.identifier] == nil {
            if emojiChoices.isEmpty {
                emojiChoices = game.emojiKey()
            }
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier]
    }
}
