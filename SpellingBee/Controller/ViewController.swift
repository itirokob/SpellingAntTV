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
    
    @IBOutlet var letterImages: [UIImageView]!
    
    var lettersArray:[Character] = []
    
    var currentWord = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        multipeerService.delegate = self
        
        currentWord = "ENCODED"//Rand
    }
    
    @IBAction func dictateWordButton(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            for imageView in self.letterImages{
                imageView.image = nil
            }
        }
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
            print("REPEAT_BUTTON")
            //Play repeat
        } else if text == "END_OF_SPEECH" {
            //Trata a palavra pra ver se está certo
            
            let inputWord = self.lettersArrayToString(lettersArray: self.lettersArray)
            
            if inputWord == currentWord {
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
                self.lettersArray = self.checkUserInput.treatUserInput(input: text.wordList, rightWord: self.currentWord)
                
                self.updateSpelledLetters(lettersArray: self.lettersArray)
            }
        }
    }
    
    func lettersArrayToString(lettersArray:[Character]) -> String{
        let characterArray = lettersArray.flatMap { $0 } // also works
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
            self.currentWord = "APPLE" //CHOOSE A NEW RAND WORD
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
