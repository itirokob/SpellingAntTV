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
    let wordService = WordsAndHintsService()
    
    @IBOutlet weak var speakButton: UIButton!
    @IBOutlet weak var connectedDevice: UILabel!
    
    var wordsAndHints: [WordAndHintDict] = []
    
    var wordsToBeChosen: [WordAndHintDict] = []
    
    @IBOutlet var letterImages: [UIImageView]!
    
    var lettersArray:[Character] = []
    
    var currentWord: WordAndHintDict = WordAndHintDict(word: "", hint: "")
    
    var randomIndex: Int = 0
    
    var timer = Timer()
    
    var isCorrect = false
    
    var isTryAgain = true
    
    var pulse = Pulsing(radius: 0, position: CGPoint(x: 0, y: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeDict()


        wordsToBeChosen = wordsAndHints
        
        multipeerService.delegate = self
        
//        randomIndex = randomNumber(max: wordsToBeChosen.count-1)
//        currentWord = wordsToBeChosen[randomIndex]
        self.wordService.requestWordAndExample(completionHandler: { (result) in
            if let currentWord = result {
                self.currentWord = currentWord
            } else {
                print("Erro na escolha da nova palavra. requestWordAndExample retornou nil")
            }
        })

    }
    
    @IBAction func dictateWordButton(_ sender: Any) {
        self.firstSpeech()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            for imageView in self.letterImages{
                imageView.image = nil
            }
            
            self.setButtonImage(button: self.speakButton, imageName: "play")
        }
        
        print(isTryAgain)
        if !isTryAgain {
            self.wordService.requestWordAndExample(completionHandler: { (result) in
                if let currentWord = result {
                    self.currentWord = currentWord
                } else {
                    print("Erro na escolha da nova palavra. requestWordAndExample retornou nil")
                }
            })
        }
    }
    
    func randomNumber(max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
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
    
    func setButtonImage(button: UIButton, imageName: String) {
        if let image = UIImage(named: imageName) {
            DispatchQueue.main.async {
                button.setImage(image, for: .normal)
            }
        }
    }
    
    func firstSpeech() {
        speakService.text2SpeechInENandGB(textToBeRead: currentWord.word)
        
        DispatchQueue.main.async {
            if(self.speakButton.currentImage == #imageLiteral(resourceName: "repeat")) {
                self.setButtonImage(button: self.speakButton, imageName: "repeat")
            }
        }
    }
    
    @IBAction func unwindToGameVC(segue:UIStoryboardSegue) { }

}

extension ViewController: MultipeerDelegate {
    
    /// The receivedText func is the common func with the other multipeer machine connected, it receives the message
    ///
    /// - Parameter text: received message
    func receivedText(text:String){
        DispatchQueue.main.async {
            if let connectedDevice = self.multipeerService.connectedPeer?.displayName{
                self.connectedDevice.text = "Connected device: " + connectedDevice
            }
        }
        
        print("Text sent: \(text)")
    
        if text == "HINT_BUTTON"{
            print("HINT_BUTTON")
            //Play hint
            speakService.textToSpeechLongSentence(textToBeRead: currentWord.hint)

        } else if text == "REPEAT_BUTTON"{
            self.firstSpeech()
            print("REPEAT_BUTTON")
            //Play repeat
        } else if text == "END_OF_SPEECH" {
            //Para o pulse
            DispatchQueue.main.async {
                self.pulse.removeFromSuperlayer()
                self.timer.invalidate()
            }
            
            //Trata a palavra pra ver se está certo
            let inputWord = self.lettersArrayToString(lettersArray: self.lettersArray)
            
            if inputWord == currentWord.word {
                self.isCorrect = true
                
                print("Right answer")
            } else {
                self.isCorrect = false
                print("Wrong answer")
            }
            
            performSegue(withIdentifier: "rightOrWrongSegue", sender: self)

            
            //Limpa o array
            self.lettersArray = []
            
            self.updateSpelledLetters(lettersArray: self.lettersArray)
            
        } else if text == "START_OF_SPEECH" {
        
            //desabilita os botões
            self.disableButtons()
            //Comeca o pulse
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.addPulse), userInfo: nil, repeats: true)
                self.timer.fire()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rightOrWrongSegue" {
            if let destination = segue.destination as? RightOrWrongViewController {
                destination.isCorrect = self.isCorrect
            }
        }
    }
    
    @objc func addPulse(){
        DispatchQueue.main.async {
            self.pulse = Pulsing(numberOfPulses: 1, radius: 300, position: self.speakButton.center)
            self.pulse.animationDuration = 1.4
            self.pulse.backgroundColor = UIColor.orange.cgColor
            
            self.view.layer.insertSublayer(self.pulse, below: self.speakButton.layer)
        }
        
    }
    
    func disableButtons() {
        DispatchQueue.main.async {

            self.speakButton.isEnabled = false
            self.setButtonImage(button: self.speakButton, imageName: "repeat-disabled")
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
//            if self.wordsToBeChosen.count > 1 {
//                self.wordsToBeChosen.remove(at: self.randomIndex)
//            } else {
//                self.wordsToBeChosen = self.wordsAndHints
//            }
//            self.randomIndex = self.randomNumber(max: self.wordsToBeChosen.count-1)
//            self.currentWord = self.wordsToBeChosen[self.randomIndex]
            
            self.wordService.requestWordAndExample(completionHandler: { (result) in
                if let currentWord = result {
                    self.currentWord = currentWord
                    print(currentWord.word)
                } else {
                    print("Erro na escolha da nova palavra. requestWordAndExample retornou nil")
                }
            })
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
