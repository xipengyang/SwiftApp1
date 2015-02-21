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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(order == nil) {
            order = appDel.newOrderAction()
        }
        
         self.setupContact()
    }
    
    func setupContact() {
        
        contacts = personDao.getContacts()
        
    }
    
    func resetProductFields(){
        productName.text = ""
        productQuantity.text = ""
        productUnitPrice.text = ""
    }
    
    @IBAction func productAddButtonAction(sender: AnyObject) {
        
        var _name = productName.text
        var _quantity = productQuantity.text
        var _unitPrice = productUnitPrice.text
        
        var _products = self.mutableSetValueForKey("products")
        
        var product: ProductD = appDel.newProductAction()
        product.setValue(_quantity, forKey: "quantity")
        product.setValue(_unitPrice, forKey: "price")
        product.setValue(_name, forKey: "productName")
        product.setValue(self.order, forKey: "order")
        
        
        resetProductFields()
        
        productTblView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filterdContacts.count
        } else if tableView == self.productTblView {
            if let products = self.order?.product {
                return products.count
            }
            return 0
        } else {
            return self.contacts.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        
        if tableView == self.productTblView {
            var cell: UITableViewCell?
            
            cell = self.productTblView.dequeueReusableCellWithIdentifier("product") as? UITableViewCell
            
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "product")
            }
            
            if let orderProduct = self.order?.product {
                var _products = orderProduct.allObjects as [ProductD]
                cell?.textLabel?.text = _products[indexPath.row].productName
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
            addressField.text = selected.address
            var customerD = appDel.getPersonByIdAction(selected.id).last
            self.order?.setValue(customerD, forKey: "customer")
            self.searchDisplayController!.setActive(false, animated: true)
            
        }
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete &&  tableView == self.productTblView {
            // Delete the row from the data source
            if let orderProducts = self.order?.product {
                var _products = orderProducts.allObjects as [ProductD]
                _products.removeAtIndex(indexPath.row)
            }
            
            tableView.reloadData()
        }
    }
    
    
    @IBAction func doneButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
