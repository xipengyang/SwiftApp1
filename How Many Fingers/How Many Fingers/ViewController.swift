//
//  ViewController.swift
//  How Many Fingers
//
//  Created by xipeng yang on 17/01/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var guess: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func GuessAction(sender: AnyObject) {
        
        var randomNumber = arc4random_uniform(6)
        var guessedNumber = guess.text.toInt()
        
        if guessedNumber != nil && Int(randomNumber) == guessedNumber {
            resultLabel.text = "You got it! I am holding \(guessedNumber) fingers"
        }else {
            resultLabel.text = "Wrong answer. Try again"
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

