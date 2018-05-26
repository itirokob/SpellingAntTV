//
//  PageViewController.swift
//  SpellingBee
//
//  Created by Bianca Itiroko on 25/05/18.
//  Copyright © 2018 Seong Eun Kim. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    @IBAction func skipAction(_ sender: Any) {
        print("Teste botão ----------------")
        performSegue(withIdentifier: "unwindSegueToGameVC", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
