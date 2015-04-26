//
//  EditStockViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 7/03/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class EditStockViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var productNameText: UILabel!
    @IBOutlet weak var quantityText: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var supplierTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (product != nil) {
            productNameText.text = product?.productName
            quantityText.text = product?.quantity
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        if (quantityTextField.text.isEmpty) {
            let alertController = UIAlertController(title: "Mistake", message:
                "Please enter quantity", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }else {
            var stock:StockD = appDel.newStockAction()
            stock.quantity = quantityTextField.text
            stock.amount = amountTextField.text
            stock.supplier = supplierTextField.text
            stock.desc = descriptionTextField.text
            stock.product = self.product!
            appDel.saveContextAction()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        appDel.rollbackAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //variables
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var product:ProductD?
    

}
