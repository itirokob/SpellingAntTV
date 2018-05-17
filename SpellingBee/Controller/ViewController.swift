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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        multipeerService.delegate = self
    }
}

extension ViewController: MultipeerDelegate {
    func receivedText(text:String){
        
        print("Text sent: \(text)")
        
        DispatchQueue.main.async {
            for imageView in self.letterImages{
                imageView.image = nil
            }
            
            let lettersArray = self.checkUserInput.treatUserInput(input: text.wordList)
            
            self.updateSpelledLetters(lettersArray: lettersArray)
        }
    }
    
    func updateSpelledLetters(lettersArray:[String]){
        for i in 0..<lettersArray.count{
            for imageView in letterImages{
                if imageView.tag == i{
                    imageView.image = UIImage(named: lettersArray[i])
                }
            }
        }
    }
}

extension String {
    var wordList: [String] {
        return components(separatedBy: .punctuationCharacters)
            .joined()
            .components(separatedBy: .whitespaces)
    }
}
