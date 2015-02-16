//
//  ViewController.swift
//  Times Tables
//
//  Created by xipeng yang on 24/01/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate {
    
    @IBOutlet weak var sliderValue: UISlider!

    @IBOutlet weak var thisView: UITableView!
    
    @IBAction func sliderMoved(sender: AnyObject) {
        thisView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        var intermediateResult = Int(sliderValue.value * 20)
        
        cell.textLabel?.text = String(intermediateResult * (indexPath.row+1))
        
        return cell
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

