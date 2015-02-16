//
//  ViewController.swift
//  Navigation
//
//  Created by xipeng yang on 19/01/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timer = NSTimer()
    var count = 0
    
    func timeout() {
        count++
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

