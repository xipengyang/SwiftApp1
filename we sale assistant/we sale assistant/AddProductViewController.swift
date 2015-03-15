//
//  AddProductViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 14/03/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController {
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var product: ProductD?
    var order: OrderD?
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productQuantity: UITextField!
    @IBOutlet weak var productAmount: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self. = "Add Product"
//        self.setupNavigationItems()
    }
    
//    private func setupNavigationItems(){
//        var rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveButtonClicked")
//        self.navigationItem.rightBarButtonItem = rightButton
//        var leftButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "backButtonClicked")
//        self.navigationItem.leftBarButtonItem = leftButton
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(product == nil) {
            product = appDel.newProductAction()
        }
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        appDel.rollbackAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        validateInput()
        var name = productName.text
        var quantity = productQuantity.text
        var unitPrice = productAmount.text
        product!.setValue(quantity, forKey: "quantity")
        product!.setValue(unitPrice, forKey: "price")
        product!.setValue(name, forKey: "productName")
        product!.setValue(self.order!, forKey: "order")
        appDel.saveContextAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func validateInput(){
        var message: String = ""
        if (productName.text.isEmpty || productQuantity.text.isEmpty || productAmount.text.isEmpty){
            message = "Please enter a text"
        }
        
        if (productQuantity.text.toInt() == nil) {
            message = "Please enter a quantity"
        }
        
        if(productAmount.text.toDouble() == nil) {
            message = "Please enter an amount"
        }
        
        let alertController = UIAlertController(title: nil,
            message: message,
            preferredStyle: .Alert)
        
        alertController.addAction(
            UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
        
        return
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

}
