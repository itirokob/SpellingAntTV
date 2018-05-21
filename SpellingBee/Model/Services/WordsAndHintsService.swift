//
//  WordsAndHintsService.swift
//  SpellingBee
//
//  Created by Bianca Itiroko on 21/05/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import Alamofire

struct Meaning:Decodable{
    let definition: String
    let example: String
}

//MyTODO: ver se realmente é necessario um struct Meaning
//MyTODO: ver um jeito de fazer o código ficar rodando até achar uma palavra com example (caso em que cai no catch)

class WordsAndHintsService {
    let wordsArray = ["excuse", "acquire", "champagne", "BANANA", "NATURE", "DISTRESS", "CULINARY","SUBTLETY", "OWL","cemeteries", "acquire", "champagne", "proselytizing", "protagonists", "quickly", "recommending", "refusal", "renown", "resurrecting", "separately", "siege", "sophisticated", "supplanted", "surprisingly", "throughout", "transcendental", "unconsciousness", "unusable", "unwieldy", "casualty", "accomplishments", "acquainted", "adolescent", "aficionados", "aggression", "airborne", "anonymity", "behavior", "canister"]
    var diceRoll:Int {
        get{
            return Int(arc4random_uniform(UInt32(wordsArray.count)))
        }
    }
    
    /// The requestExample func returns word and example
    ///
    /// - Parameters:
    ///   - completionHandler: WordAndHintDict object with the word and example
    func requestWordAndExample(completionHandler: @escaping (WordAndHintDict?) -> ()) {
        let word = wordsArray[diceRoll].lowercased()
        print(word)
        let url = URL(string: "https://owlbot.info/api/v2/dictionary/\(word)")
        
        Alamofire.request(url!).responseJSON(completionHandler: { (response) in
            let result = response.data
            do {
                let meaning = try JSONDecoder().decode([Meaning].self, from: result!)
                completionHandler(WordAndHintDict(word: word, hint: meaning[0].example))
            } catch {
                print("error")
                completionHandler(nil)
            }
        })
    }
    
}

