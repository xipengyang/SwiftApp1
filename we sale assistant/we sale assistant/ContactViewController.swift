//
//  FirstViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 6/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var viewTable: UITableView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        personDao.refreshContacts()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewTable.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let contact: Contact  = personDao.getContacts()[indexPath.row]
        
        var destViewController: PersonDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PersonDetailController") as! PersonDetailViewController
        
        if(indexPath.row >= 0) {
            
            if let person: Person  = personDao.getPersonAtIndex(contact.id.toInt()!) {
            
            destViewController.id = person.id!.stringValue
            destViewController.name = person.name
            destViewController.phone = person.phone
            destViewController.weChatId = person.weChatId
            destViewController.address = person.address
            destViewController.orders =  person.orders.allObjects as? [OrderD]
            destViewController.person = person
            
            self.presentViewController(destViewController, animated: true, completion: nil)
            }
        
        }
        
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let contact: Contact  = personDao.getContacts()[indexPath.row]
            let person: Person = personDao.getPersonAtIndex(contact.id.toInt()!)!
            personDao.deletePerson(person)
            personDao.deleteContacts(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            appDel.saveContextAction()
        }
    }
}

