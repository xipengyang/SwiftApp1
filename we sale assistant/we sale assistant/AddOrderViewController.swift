//
//  AddOrderViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 7/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit
import Dollar

class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var productTblView: UITableView!
    @IBOutlet weak var custSearchTblView: UITableView!
    @IBOutlet weak var customerName: UILabel!
    //@IBOutlet weak var addressField: UITextView!
    @IBOutlet weak var addProductBtn: MKButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func backButtonClicked(sender: AnyObject) {
        appDel.rollbackAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveButtonClicked(sender: AnyObject) {
        appDel.saveContextAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func customerButtonClicked(sender: AnyObject) {
        var current = self.searchBar.hidden
        self.searchBar.hidden = !current
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        prepareData()
        productTblView.reloadData()
    }
    
    private func prepareData() {
    if let customer = order?.customer {
                self.customerName.text = customer.name
                //self.addressField.text  = customer.address
    }
//    products = self.order!.products.sortedArrayUsingDescriptors([NSSortDescriptor(key: "productName", ascending: true, selector: "localizedStandardCompare:")]) as! [ProductD]
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
                cell?.rightLabel.text = "$ \(amountSum)"
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
            customerName.text = selected.name!
            //addressField.text = selected.address
            var customerD = appDel.getPersonByIdAction(selected.id.toInt()!).last
            self.order?.setValue(customerD, forKey: "customer")
            self.searchDisplayController!.setActive(false, animated: true)
        } else if(tableView == self.productTblView && indexPath.row < products.count) {
            let selectedProduct = products[indexPath.row]
            var destView :AddProductViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddProductViewController") as! AddProductViewController
            destView.product = selectedProduct
            self.presentViewController(destView, animated: true, completion: nil)
        }
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete &&  tableView == self.productTblView && products.count > 0 {
            // rollback data
            let selectedProduct = products[indexPath.row] as ProductD
//            if(!selectedProduct.price.isEmpty){
//                if let price = selectedProduct.price.toDouble(){
//                    self.totalAmount -= price
//                }
//            }
            appDel.deleteObjectAction(selectedProduct)
            //products.removeAtIndex(indexPath.row)
            appDel.saveContextAction()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            productTblView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "addProduct") {
            let destViewController:AddProductViewController = segue.destinationViewController as! AddProductViewController
            destViewController.order = self.order
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
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

//    Variable initialization
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    lazy var contacts:[Contact] = {
        return personDao.getContacts()
    }()
    var filterdContacts = [Contact]()
    var customer: Contact? = nil
    
    lazy var order: OrderD? = {
        [unowned self] in
        let newOrder = self.appDel.newOrderAction()
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString:String = dateFormatter.stringFromDate(date)
        newOrder.setValue(dateString, forKey: "orderDate")
        newOrder.setValue("New", forKey:"status")
        return newOrder
        }()
    
    var products: [ProductD] {
        get{
            return self.order!.products.sortedArrayUsingDescriptors([NSSortDescriptor(key: "productName", ascending: true, selector: "localizedStandardCompare:")]) as! [ProductD]
        }
    }
    
    var amountSum: Double {
        get{
            return $.reduce(products, initial: 0.0) { (total, element) in
                let product = element as ProductD
                if(!product.price.isEmpty){
                    if let amt = product.price.toDouble(){
                        return total + amt
                    }
                }
                return total
            }
        }
    }
    
}
