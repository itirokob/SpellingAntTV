//
//  SpeakService.swift
//  SpellingBee
//
//  Created by Bianca Itiroko on 18/05/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import Foundation
import AVFoundation

class SpeakService:NSObject, AVSpeechSynthesizerDelegate {
    var synthesizer:AVSpeechSynthesizer?

    func text2Speech(textToBeRead: String) {
        if (synthesizer == nil)
        {
            synthesizer = AVSpeechSynthesizer()
            synthesizer?.delegate = self
            
            let utterance = AVSpeechUtterance(string: textToBeRead)
            utterance.rate = 0.3
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            
            utterance.pitchMultiplier = 1.3
            print("\(utterance.voice!)")
            
            synthesizer!.speak(utterance)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.synthesizer = nil
        print("FINISHED")
    }
}
