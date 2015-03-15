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
    @IBOutlet weak var productUnitPrice: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Product"
        self.setupNavigationItems()
    }
    
    private func setupNavigationItems(){
        var rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveButtonClicked")
        self.navigationItem.rightBarButtonItem = rightButton
        var leftButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "backButtonClicked")
    }
    
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
                if (productName.text.isEmpty){
                    let message = "Please enter a text and then press Share"
        
                    let alertController = UIAlertController(title: nil,
                        message: message,
                        preferredStyle: .Alert)
        
                    alertController.addAction(
                        UIAlertAction(title: "OK", style: .Default, handler: nil))
        
                    presentViewController(alertController, animated: true, completion: nil)
                    
                    return
                }
        var name = productName.text
        var quantity = productQuantity.text
        var unitPrice = productUnitPrice.text
        product!.setValue(quantity, forKey: "quantity")
        product!.setValue(unitPrice, forKey: "price")
        product!.setValue(name, forKey: "productName")
        product!.setValue(self.order!, forKey: "order")
        appDel.saveContextAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

}
