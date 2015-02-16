//
//  ViewController.swift
//  Cat Years
//
//  Created by xipeng yang on 11/01/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ageInput: UITextField!
    
    
    @IBOutlet weak var ageOutput: UILabel!
    
    @IBAction func findByAgePressed(sender: AnyObject) {
        println(ageInput.text)
        
        var enteredAge = ageInput.text.toInt()
        
        if enteredAge != nil {
        var catYears = enteredAge! * 7
        
        ageOutput.text = "Your cat is \(catYears)"
        
        } else {
            ageOutput.text = "Please enter a whole number"
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

