//
//  FirstViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 6/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var viewTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTable.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personDao.getContacts().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        cell = tableView.dequeueReusableCellWithIdentifier("contact") as? UITableViewCell
        
        if( cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "contact")
        }
        
        let contact = personDao.getContacts()[indexPath.row]
        
        cell!.textLabel?.text = contact.name
        
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let contact: Contact  = personDao.getContacts()[indexPath.row]
        println(contact.name)
        
        
        var destViewController: PersonDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PersonDetailController") as PersonDetailViewController
        
        if(indexPath.row >= 0) {
            let contact: Contact  = personDao.getContacts()[indexPath.row]
            
            destViewController.name = contact.name
            
            destViewController.phone = contact.phone

            destViewController.weChatId = contact.weChatId
            
            destViewController.address = contact.address
        }

        
        self.presentViewController(destViewController, animated: true, nil)
        
    }    
    


}

