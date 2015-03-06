//
//  AddOrderViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 7/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var contacts = [Contact]()
    
    var filterdContacts = [Contact]()
    
    var products = [ProductD]()
    
    var customer: Contact? = nil
    
    var order: OrderD?
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    @IBOutlet weak var productTblView: UITableView!
    
    @IBOutlet weak var custSearchTblView: UITableView!
    
    @IBOutlet weak var customerName: UILabel!
    
    @IBOutlet weak var addressField: UITextView!
    
    @IBOutlet weak var productName: UITextField!
    
    @IBOutlet weak var productQuantity: UITextField!
    
    @IBOutlet weak var productUnitPrice: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func prepareData() {
        if(order == nil) {
            order = appDel.newOrderAction()
            setOrderDateToNow()
        } else {
            if let customer = order?.customer {
                self.customerName.text = customer.name
                self.addressField.text  = customer.address
            }
        }
        contacts = personDao.getContacts()
        products = self.order?.product.allObjects as [ProductD]
    }
    
    private func setOrderDateToNow() {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString:String = dateFormatter.stringFromDate(date)
        println("order date string - \(dateString)")
        self.order?.setValue(dateString, forKey: "orderDate")
    }
    
    private func resetProductFields(){
        productName.text = ""
        productQuantity.text = ""
        productUnitPrice.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filterdContacts.count
        } else if tableView == self.productTblView {
            return self.products.count
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
            

            let thisProduct = products[indexPath.row]
            cell?.leftLabel.text = thisProduct.productName
            cell?.middleLabel.text = thisProduct.quantity
            cell?.rightLabel.text = thisProduct.price
            
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
            addressField.text = selected.address
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
            appDel.deleteObjectAction(selectedProduct)
            products.removeAtIndex(indexPath.row)
            //tableView.reloadData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        appDel.rollbackAction()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        if (self.order?.customer == nil) {
            let alertController = UIAlertController(title: "Mistake", message:
                "Please select a customer", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }else {
        appDel.saveContextAction()
        self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func productAddButtonAction(sender: AnyObject) {
        
        var name = productName.text
        var quantity = productQuantity.text
        var unitPrice = productUnitPrice.text
        var product: ProductD = appDel.newProductAction()
        product.setValue(quantity, forKey: "quantity")
        product.setValue(unitPrice, forKey: "price")
        product.setValue(name, forKey: "productName")
        product.setValue(self.order, forKey: "order")
        self.products.append(product)
        resetProductFields()
        productTblView.reloadData()
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    
}
