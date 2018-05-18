//
//  WordAndHintDict.swift
//  SpellingBee
//
//  Created by Seong Eun Kim on 18/05/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation

class WordAndHintDict: NSObject {
    var word: String = ""
    var hint: String = ""
    
    init(word: String, hint: String) {
        super.init()
        self.word = word
        self.hint = hint
    }
}
