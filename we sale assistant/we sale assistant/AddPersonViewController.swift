//
//  AddPersonViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 7/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit
import CoreData

class AddPersonViewController: UIViewController {
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var phoneInput: UITextField!
    @IBOutlet weak var wechatInput: UITextField!
    @IBOutlet weak var addressInput: UITextView!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var weChatLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameInput.borderStyle = UITextBorderStyle.None
        //setup()
        // Do any additional setup after loading the view, typically from a nib.
        telephoneLabel.text = GoogleIcon.e7e9
        telephoneLabel.textColor = UIColor.grayColor()
        addressLabel.text = GoogleIcon.e7e1
        addressLabel.textColor = UIColor.grayColor()
        weChatLabel.text = GoogleIcon.e60c
        weChatLabel.textColor = UIColor.grayColor()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveButtonAction(sender: AnyObject) {
        
        var phoneNumber: Int16
        var weChatId: Int16
        let zero: Int16 = 0
        let contactType: String = "Customer"
        
        if (nameInput.text!.isEmpty) {
            let alertController = UIAlertController(title: "Mistake", message:
                "Please enter a name", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            personDao.addPerson(nameInput.text, address: addressInput.text,phone: phoneInput.text ,weChatId: wechatInput.text, personType: contactType)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        appDel.rollbackAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   
}
