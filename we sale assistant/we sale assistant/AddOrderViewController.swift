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
    
    var products = [Product]()
    
    var customer: Contact? = nil
    
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
        
        var _quantity = productQuantity.text != nil ? productQuantity.text.toInt() : 0
        
        var _unitPrice = productUnitPrice.text != nil ? (productUnitPrice.text as NSString).doubleValue : 0.0
        
        products.append(Product(name: productName.text, quantity: _quantity, unitPrice: _unitPrice))
        
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
            return self.products.count
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
            
            var product: Product
            
            product  = products[indexPath.row]
            
            cell?.textLabel?.text = product.name
            
            return cell!
            
        }else {
            var cell: UITableViewCell?
            
            cell = tableView.dequeueReusableCellWithIdentifier("customer") as? UITableViewCell
            
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "customer")
            }
            
            var customer : Contact
            // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
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
            self.searchDisplayController!.setActive(false, animated: true)
            
        }
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete &&  tableView == self.productTblView {
            // Delete the row from the data source
            products.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    @IBAction func doneButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
