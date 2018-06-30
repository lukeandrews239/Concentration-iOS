//
//  Card.swift
//  ConcentrationGame
//
//  Created by Luke Andrews on 6/28/18.
//  Copyright © 2018 Luke Andrews. All rights reserved.
//

import Foundation

struct Card
{
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    var hasFlipped = false

    static var identifierFactory = 0

    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }

    init() {
        self.identifier = Card.getUniqueIdentifier()
    }

}
