//
//  AddProductViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 14/03/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var productName: MKTextField!
    @IBOutlet weak var productQuantity: MKTextField!
    @IBOutlet weak var productAmount: MKTextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var amountSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productName.layer.borderColor = UIColor.clearColor().CGColor
        productName.floatingPlaceholderEnabled = true
        productName.placeholder = "Product Name"
        productName.rippleLocation = .TapLocation
        productName.cornerRadius = 0
        productName.bottomBorderEnabled = true
        productQuantity.layer.borderColor = UIColor.clearColor().CGColor
        productQuantity.placeholder = "How Many"
        productQuantity.rippleLocation = .TapLocation
        productQuantity.cornerRadius = 0
        productQuantity.bottomBorderEnabled = true
        productAmount.layer.borderColor = UIColor.clearColor().CGColor
        productAmount.placeholder = "How Much"
        productAmount.rippleLocation = .TapLocation
        productAmount.cornerRadius = 0
        productAmount.bottomBorderEnabled = true
        //binds model to view
        modelBindView()
    }
    
    private func modelBindView() {
        if( self.product != nil) {
            if let nameData = self.product!.productName as String? {
                productName.text = nameData
            }
            if let quantityData = self.product!.quantity {
                productQuantity.text = quantityData.stringValue
            }
            if let amountData = self.product!.price{
                productAmount.text = amountData.stringValue
            }
            if let imageData = self.product!.image as NSData? {
                pickedImage.image = UIImage(data: imageData)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        if(!validateInput()){
            let alertController = UIAlertController(title: nil,
                message: errorMsg,
                preferredStyle: .Alert)
            
            alertController.addAction(
                UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        let nameText = productName.text
        let quantityText = productQuantity.text
        let amountText = productAmount.text
        
        
        if product == nil {
            product = self.appDel.newProductAction()
        }
        
        
        if(amountSegment.selectedSegmentIndex == 1 && quantity != 0) {
            //to do - NSDecimalNumberBehaviors?
            let productQuantity: NSDecimalNumber = NSDecimalNumber(integer: quantity)
            product!.price = amount.decimalNumberByMultiplyingBy(productQuantity)
        } else {
            product!.price = self.amount
        }
        
        product!.quantity = quantity
        
        product!.setValue(nameText, forKey: "productName")
        
        if let myImage = self.pickedImage.image {
            product!.setValue(UIImageJPEGRepresentation(myImage, 1), forKey: "image")
        }
        if let parentOrder = self.order as OrderD? {
            product!.setValue(parentOrder, forKey: "order")
        }
        
        appDel.saveContextAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func validateInput() -> Bool{
        var valid: Bool = true
        if (productName.text.isEmpty || productQuantity.text.isEmpty || productAmount.text.isEmpty){
            valid = false
            errorMsg = "Please enter a name, a quantity and an amount"
        }
        else if (productQuantity.text.toInt() == nil || productAmount.text.toDouble() == nil) {
            valid = false
            errorMsg = "Please enter a number"
        }
        return valid
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.view.endEditing(true);
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.pickedImage.image = image
    }
    
    
    @IBAction func addImageBtnClicked(sender: AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)) {
            let imageCtrl = UIImagePickerController()
            imageCtrl.delegate = self
            imageCtrl.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imageCtrl.allowsEditing = false
            self.presentViewController(imageCtrl, animated: true, completion: nil)
        }else {
            let alertController = UIAlertController(title: nil,
                message: "Please allow the app to access your photo library.",
                preferredStyle: .Alert)
            
            alertController.addAction(
                UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
            return
            
        }
    }
    
    //variables
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var product: ProductD?
    var amount: NSDecimalNumber! {
        get {
            if let value = productAmount.text {
                return NSDecimalNumber(string: value)
            }
            return NSDecimalNumber.zero()
        }
    }
    
    var quantity: Int! {
        get {
             return productQuantity.text.toInt() ?? 0
        }
    }
    
    lazy var errorMsg: String? = {
        return "Unknown Error. Please contact support."
        }()
    var order: OrderD?
}
