//
//  AddProductViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 14/03/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    
    var product: ProductD?
    
    private func _initProduct() -> ProductD {
        var _newInstance = self.appDel.newProductAction()
        return _newInstance
    }
    
    lazy var errorMsg: String? = {
        return "Unknown Error. Please contact support."
    }()
    
    var order: OrderD?
    @IBOutlet weak var productName: MKTextField!
    @IBOutlet weak var productQuantity: MKTextField!
    @IBOutlet weak var productAmount: MKTextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var pickedImage: UIImageView!
    
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
        //binds model to view
        modelBindView()
    }
    
    private func modelBindView() {
        if( self.product != nil) {
        if let nameData = self.product!.productName as String? {
            productName.text = nameData
        }
        if let quantityData = self.product!.quantity as String? {
            productQuantity.text = quantityData
        }
        if let amountData = self.product!.price as String? {
            productAmount.text = amountData
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
        var name = productName.text
        var quantity = productQuantity.text
        var unitPrice = productAmount.text
        if product == nil {
            product = _initProduct()
        }
        product!.setValue(quantity, forKey: "quantity")
        product!.setValue(unitPrice, forKey: "price")
        product!.setValue(name, forKey: "productName")
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
    
    
    func imagePickerController(didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.pickedImage.image = image
    }
    
    @IBAction func addImageBtnClicked(sender: AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)) {
        var imageCtrl = UIImagePickerController()
        imageCtrl.delegate = self
        imageCtrl.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imageCtrl.allowsEditing = false
        self.presentViewController(imageCtrl, animated: true, completion: nil)
        }
    }
}
