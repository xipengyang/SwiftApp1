//
//  PersonDetailViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 7/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {
    
    
    @IBOutlet weak var nameInput: UITextField!
    
    @IBOutlet weak var phoneInput: UITextField!
    
    @IBOutlet weak var wechatInput: UITextField!
    
    @IBOutlet weak var addressInput: UITextView!
    
    @IBOutlet weak var isSupplier: UISwitch!
    
    
    var name:String?
    var address:String?
    var phone:String?
    var weChatId:String?
    var notes:String?
    
    @IBAction func DoneButtonAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
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
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

