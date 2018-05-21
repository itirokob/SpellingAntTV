//
//  RightOrWrongViewController.swift
//  SpellingBee
//
//  Created by Seong Eun Kim on 21/05/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

class RightOrWrongViewController: UIViewController {
    var isCorrect = false
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    var isTryAgain = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async{        
            if self.isCorrect {
                self.feedbackLabel.text = "CONGRATULATIONS!"
                self.button1.setTitle("NEXT WORD", for: .normal)
                self.button2.setTitle("TRY AGAIN", for: .normal)
                
            } else {
                self.feedbackLabel.text = "YOU GOT IT WRONG!"
                self.button1.setTitle("TRY AGAIN", for: .normal)
                self.button2.setTitle("NEXT WORD", for: .normal)
            }
        }
    }

    
    @IBAction func button1Action(_ sender: UIButton) {
        if sender.title(for: .normal) == "NEXT WORD"{
            print("Next word")
            self.isTryAgain = false
        } else if sender.title(for: .normal) == "TRY AGAIN"{
            self.isTryAgain = true
        }
        
        performSegue(withIdentifier: "unwindSegueToGameVC", sender: self)

    }
    
    @IBAction func button2Action(_ sender: UIButton) {
        if sender.title(for: .normal) == "NEXT WORD"{
            self.isTryAgain = false
        } else if sender.title(for: .normal) == "TRY AGAIN"{
            self.isTryAgain = true
        }
        performSegue(withIdentifier: "unwindSegueToGameVC", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindSegueToGameVC"{
            if let destination = segue.destination as? ViewController {
                destination.isTryAgain = self.isTryAgain
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
