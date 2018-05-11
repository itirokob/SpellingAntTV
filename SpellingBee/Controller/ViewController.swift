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
    
    @IBOutlet weak var messagePrint: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        multipeerService.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: MultipeerDelegate {
    func receivedText(text:String){
        print("Text sent: \(text)")
        
        DispatchQueue.main.async {
            self.messagePrint.text = text + String(arc4random())
        }
    }
}

