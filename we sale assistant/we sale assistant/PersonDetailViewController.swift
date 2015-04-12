//
//  PersonDetailViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 7/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var phoneInput: UITextField!
    @IBOutlet weak var wechatInput: UITextField!
    @IBOutlet weak var addressInput: UITextView!
    @IBOutlet weak var isSupplier: UISwitch!
    @IBOutlet weak var orderHistoryTableView: UITableView!
    
    
    var name:String?
    var address:String?
    var phone:String?
    var weChatId:String?
    var notes:String?
    var id:String!
    var orders: [OrderD]?
    var person: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameInput.text = name
        if(phone != nil) {
        self.phoneInput.text = phone
        }
        if(weChatId != nil) {
        self.wechatInput.text = weChatId
        }
        self.addressInput.text = address
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let unwrapped = orders {
            return unwrapped.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        cell = self.orderHistoryTableView.dequeueReusableCellWithIdentifier("orderHistoryCell") as? UITableViewCell
        
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "order")
        }
        
        if( orders != nil) {
            let orderAtRow = orders![indexPath.row]
            let products: [ProductD] = orderAtRow.products.allObjects as! [ProductD]
            var bodyText = ""
            for product in products {
                bodyText = ("\(bodyText) \(product.productName)  \(product.quantity)")
            }
            cell!.detailTextLabel?.text = bodyText
            cell!.textLabel?.text = orderAtRow.orderDate
        }
        
        return cell!

    }
    
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        personDao.savePerson(id, name: self.nameInput.text, address: self.addressInput.text, phone: self.phoneInput.text, weChatId: self.wechatInput.text, personType: "customer")
        person.name = self.nameInput.text
        person.address = self.addressInput.text
        person.phone = self.phoneInput.text
        person.weChatId = self.wechatInput.text
        appDel.saveContextAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        appDel.rollbackAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

