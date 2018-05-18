//
//  ViewController.swift
//  SpellingBee
//
//  Created by Bianca Itiroko on 09/05/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let multipeerService = MultipeerService()
    let checkUserInput = TreatInputService()
    let speakService = SpeakService()
    
    var wordsAndHints: [WordAndHintDict] = []
    
    @IBOutlet var letterImages: [UIImageView]!
    
    var lettersArray:[Character] = []
    
    var currentWord: WordAndHintDict = WordAndHintDict(word: "", hint: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeDict()
        
        multipeerService.delegate = self
        
        currentWord = wordsAndHints[Int(arc4random_uniform(UInt32(wordsAndHints.count-1)))]
    }
    
    @IBAction func dictateWordButton(_ sender: Any) {
        speakService.text2Speech(textToBeRead: currentWord.word)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            for imageView in self.letterImages{
                imageView.image = nil
            }
        }
    }
    
    func initializeDict() {
        wordsAndHints.append(WordAndHintDict(word: "BANANA", hint: "I like to eat banana in the morning."))
        wordsAndHints.append(WordAndHintDict(word: "PEACE", hint: "The world needs peace."))
        wordsAndHints.append(WordAndHintDict(word: "MICROSCOPE", hint: "Giovani has a microscope."))
        wordsAndHints.append(WordAndHintDict(word: "APPLE", hint: "Do you like apple?"))
        wordsAndHints.append(WordAndHintDict(word: "NATURE", hint: "Nature helps you to distress."))
        wordsAndHints.append(WordAndHintDict(word: "DISTRESS", hint: "I distress to calm my mind."))
        wordsAndHints.append(WordAndHintDict(word: "MUGGLE", hint: "Kim is a muggle."))
        wordsAndHints.append(WordAndHintDict(word: "CULINARY", hint: "The early colonists used herbs for both culinary and medical purposes."))
        wordsAndHints.append(WordAndHintDict(word: "SUBTLETY", hint: "When asking his mom a favor, Gary prefered subtlety to a more direct approach."))
        wordsAndHints.append(WordAndHintDict(word: "TOUT", hint: "Grace didn't enjoy how the television host would always tout his own products during every episode."))
        wordsAndHints.append(WordAndHintDict(word: "PEDDLE", hint: "He was going to peddle T-shirts on the beach."))
        wordsAndHints.append(WordAndHintDict(word: "BOWYER", hint: "Her father worked as a bowyer."))
        wordsAndHints.append(WordAndHintDict(word: "SORTILEGE", hint: "One example of sortilege is when sailors cast lots to discover why God is angry."))
        wordsAndHints.append(WordAndHintDict(word: "REVERBERANT", hint: "We could hear the wolf's reverberant call from the hills."))
        wordsAndHints.append(WordAndHintDict(word: "MACARONIC", hint: "Peter's conversations with his parents are a macaronic affair, since his parents speak almost entirely in Mandarin while he responds to them mostly in English.."))
        wordsAndHints.append(WordAndHintDict(word: "FILAR", hint: "Mrs. Jensen instructed the students to use a filar microscope to take a more accurate measurement of their specimen."))
        wordsAndHints.append(WordAndHintDict(word: "THERIATRICS", hint: "Joanna bewildered all her friends when she said that her father is a specialist in theriatrics."))
        
    }
}

extension ViewController: MultipeerDelegate {
    
    /// The receivedText func is the common func with the other multipeer machine connected, it receives the message
    ///
    /// - Parameter text: received message
    func receivedText(text:String){
        print("Text sent: \(text)")
    
        if text == "HINT_BUTTON"{
            print("HINT_BUTTON")
            //Play hint
        } else if text == "REPEAT_BUTTON"{
            speakService.text2Speech(textToBeRead: currentWord.word)
            print("REPEAT_BUTTON")
            //Play repeat
        } else if text == "END_OF_SPEECH" {
            //Trata a palavra pra ver se está certo
            
            let inputWord = self.lettersArrayToString(lettersArray: self.lettersArray)
            
            if inputWord == currentWord.word {
                popAlert(title: "YAY", message: "Right answer!")
                print("Right answer")
            } else {
                popAlert(title: "Oh no!", message: "Wrong answer!")
                print("Wrong answer")
            }
        } else {
            DispatchQueue.main.async {
                for imageView in self.letterImages{
                    imageView.image = nil
                }
                self.lettersArray = self.checkUserInput.treatUserInput(input: text.wordList, rightWord: self.currentWord.word)
                
                self.updateSpelledLetters(lettersArray: self.lettersArray)
            }
        }
    }
    
    func lettersArrayToString(lettersArray:[Character]) -> String{
        let characterArray = lettersArray.compactMap { $0 } // also works
        let string = String(characterArray)
        return string
    }
    
    func popAlert(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Try again", comment: "Try again"), style: .default, handler: { _ in
            NSLog("The \"try again\" alert occured.")
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Next", comment: "Next"), style: .default, handler: { _ in
            NSLog("The \"next\" alert occured.")
            self.currentWord = self.wordsAndHints[Int(arc4random_uniform(UInt32(self.wordsAndHints.count-1)))]
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    /// The updateSpelledLetters func transforms the letters received with multipeer in the images displayed
    ///
    /// - Parameter lettersArray: letters to be shown
    func updateSpelledLetters(lettersArray:[Character]){
        for i in 0..<lettersArray.count{
            for imageView in letterImages{
                if imageView.tag == i{
                    imageView.image = UIImage(named: String(lettersArray[i]))
                }
            }
        }
    }
}


// MARK: - Transforms a string to a list of words
extension String {
    var wordList: [String] {
        return components(separatedBy: .punctuationCharacters)
            .joined()
            .components(separatedBy: .whitespaces)
    }
}
