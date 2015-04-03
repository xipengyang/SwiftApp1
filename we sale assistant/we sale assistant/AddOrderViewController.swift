//
//  AddOrderViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 7/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    lazy var contacts = [Contact]()
    lazy var filterdContacts = [Contact]()
    var customer: Contact? = nil
    lazy var order: OrderD? = {
        [unowned self] in
        return self.appDel.newOrderAction()
    }()
    lazy var products: [ProductD] = {
        [unowned self] in
        return self.order!.products.allObjects as [ProductD]
     }()
    var totalAmount: Int = 0
    @IBOutlet weak var productTblView: UITableView!
    @IBOutlet weak var custSearchTblView: UITableView!
    @IBOutlet weak var customerName: UILabel!
    //@IBOutlet weak var addressField: UITextView!
    @IBOutlet weak var addProductBtn: MKButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        prepareData()
        productTblView.reloadData()
    }
    
    private func prepareData() {
        if(order?.orderDate == nil) {
            setOrderDateToNow()
        }
        if let customer = order?.customer {
                self.customerName.text = customer.name
                //self.addressField.text  = customer.address
        }
        contacts = personDao.getContacts()
        var total: Int = 0
        products = self.order?.products.allObjects as [ProductD]
        for product in products {
            if(!product.price.isEmpty){
                 if let amt = product.price.toInt(){
                        total = total + amt
                    }
                }
            }
        totalAmount = total
    }
    
    private func setOrderDateToNow() {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString:String = dateFormatter.stringFromDate(date)
        println("order date string - \(dateString)")
        self.order?.setValue(dateString, forKey: "orderDate")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filterdContacts.count
        } else if tableView == self.productTblView {
            return self.products.count + 1
        } else {
            return self.contacts.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        
        if tableView == self.productTblView {
            var cell: OrderProductCell?
            
            cell = self.productTblView.dequeueReusableCellWithIdentifier("product") as? OrderProductCell
            
            if (cell == nil) {
                cell = OrderProductCell(style: UITableViewCellStyle.Default, reuseIdentifier: "product")
            }
            
            if(indexPath.row == products.count){
                cell?.leftLabel.text = "TOTAL"
                cell?.middleLabel.text = ""
                cell?.rightLabel.text = "$ \(totalAmount)"
                cell?.backgroundColor = UIColor.redColor()
            }else {
                let thisProduct = products[indexPath.row]
                cell?.leftLabel.text = thisProduct.productName
                cell?.middleLabel.text = thisProduct.quantity
                cell?.rightLabel.text = "$ \(thisProduct.price)"
                if (thisProduct.image != nil) {
                    cell?.leftImage.image = UIImage(data: thisProduct.image!)
                }else {
                    cell?.leftImage.image = nil
                }
                cell?.backgroundColor = UIColor.whiteColor()
            }
            
            return cell!
            
        }else {
            var cell: UITableViewCell?
            
            cell = tableView.dequeueReusableCellWithIdentifier("customer") as? UITableViewCell
            
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "customer")
            }
            
            var customer : Contact

            if tableView == self.searchDisplayController!.searchResultsTableView {
                customer = filterdContacts[indexPath.row]
            } else {
                customer = contacts[indexPath.row]
            }
            
            // Configure the cell
            cell?.textLabel?.text = customer.name
            
            return cell!
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filterdContacts = self.contacts.filter({( contact : Contact) -> Bool in
            var stringMatch = contact.name!.rangeOfString(searchText)
            return stringMatch != nil
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString, scope: "ALL")
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            let selected = filterdContacts[indexPath.row]
            customerName.text = selected.name
            //addressField.text = selected.address
            var customerD = appDel.getPersonByIdAction(selected.id.toInt()!).last
            self.order?.setValue(customerD, forKey: "customer")
            self.searchDisplayController!.setActive(false, animated: true)
            
        }
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete &&  tableView == self.productTblView {
            // rollback data
            let selectedProduct = products[indexPath.row] as ProductD
            if(!selectedProduct.price.isEmpty){
                if let price = selectedProduct.price.toInt(){
                    self.totalAmount -= price
                }
            }
            appDel.deleteObjectAction(selectedProduct)
            products.removeAtIndex(indexPath.row)
            appDel.saveContextAction()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "addProduct") {
            let destViewController:AddProductViewController = segue.destinationViewController as AddProductViewController
            destViewController.order = self.order
        }
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        appDel.rollbackAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
//        if (self.order?.customer == nil) {
//            let alertController = UIAlertController(title: "Mistake", message:
//                "Please select a customer", preferredStyle: UIAlertControllerStyle.Alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
//            self.presentViewController(alertController, animated: true, completion: nil)
//        }else {
        appDel.saveContextAction()
        self.dismissViewControllerAnimated(true, completion: nil)
        //}
    }
    
    
    
    @IBAction func handleShare(sender: UIButton){
        
        let image = createOrderImage()
        
        /* it is VERY important to cast your strings to NSString
        otherwise the controller cannot display the appropriate sharing options */
        // look for "applicationActivities"
        var activityView = UIActivityViewController(
            activityItems: [image, "WeSale Assistant"],
            //applicationActivities: [WeChatSessionActivity()])
            applicationActivities: nil)
        
        presentViewController(activityView,
            animated: true,
            completion: {
        })
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func createOrderImage() -> UIImage!{
        //Create the UIImage
        UIGraphicsBeginImageContext(productTblView.frame.size)
        productTblView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
}
