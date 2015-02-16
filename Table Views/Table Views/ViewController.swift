//
//  ViewController.swift
//  Table Views
//
//  Created by xipeng yang on 24/01/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    let values:[String] = ["a", "b", "c","d"]
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = values[indexPath.row]
        let anotherCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "AnotherCell")
        anotherCell.textLabel?.text = "odd"
        
        if(indexPath.row % 2 == 0) {
            return cell
        }
        else {
            return anotherCell
        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

