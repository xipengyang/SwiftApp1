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
        personDao.refreshContacts()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        personDao.refreshContacts()
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
            
            if let person: Person  = personDao.getPersonAtIndex(contact.id.toInt()!) {
            
            destViewController.id = person.id.stringValue
            destViewController.name = person.name
            destViewController.phone = person.phone
            destViewController.weChatId = person.weChat_id
            destViewController.address = person.address
            destViewController.orders =  person.order.allObjects as? [OrderD]
            
            self.presentViewController(destViewController, animated: true, nil)
            }
        
        }
        
    }    
    


}

