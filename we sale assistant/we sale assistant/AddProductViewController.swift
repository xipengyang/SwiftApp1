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
    
    lazy var product: ProductD? = {
        var newProduct = self.appDel.newProductAction()
        return newProduct
    }()
    
    var order: OrderD?
    @IBOutlet weak var productName: MKTextField!
    @IBOutlet weak var productQuantity: MKTextField!
    @IBOutlet weak var productAmount: MKTextField!
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productName.layer.borderColor = UIColor.clearColor().CGColor
        productName.floatingPlaceholderEnabled = true
        productName.placeholder = "Product Name"
        productName.tintColor = UIColor.MKColor.Blue
        productName.rippleLocation = .TapLocation
        productName.cornerRadius = 0
        productName.bottomBorderEnabled = true
        productQuantity.layer.borderColor = UIColor.clearColor().CGColor
        productQuantity.placeholder = "How Many"
        productQuantity.tintColor = UIColor.MKColor.Blue
        productQuantity.rippleLocation = .TapLocation
        productQuantity.cornerRadius = 0
        productQuantity.bottomBorderEnabled = true
        productAmount.layer.borderColor = UIColor.clearColor().CGColor
        productAmount.placeholder = "How Much"
        productAmount.tintColor = UIColor.MKColor.Blue
        productAmount.rippleLocation = .TapLocation
        productAmount.cornerRadius = 0
        productAmount.bottomBorderEnabled = true
        //self. = "Add Product"
//        self.setupNavigationItems()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        appDel.rollbackAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        if(!validateInput()){
                let alertController = UIAlertController(title: nil,
                    message: "Please enter a valid information",
                    preferredStyle: .Alert)
                
                alertController.addAction(
                    UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                presentViewController(alertController, animated: true, completion: nil)
            return
        }
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
    
    private func validateInput() -> Bool{
        var message: String = ""
        var valid: Bool = true
        if (productName.text.isEmpty || productQuantity.text.isEmpty || productAmount.text.isEmpty){
            valid = false
            message = "Please enter a text"
        }
        else if (productQuantity.text.toInt() == nil) {
            valid = false
            message = "Please enter a quantity"
        }
        else if(productAmount.text.toDouble() == nil) {
            valid = false
            message = "Please enter an amount"
        }
        return valid
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

}
