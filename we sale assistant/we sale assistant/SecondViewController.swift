//
//  SecondViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 6/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var orders: [OrderD] = [OrderD]()
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        orderDao.load()
        orders = orderDao.getOrders()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: OrderCell?
        cell = self.tableView.dequeueReusableCellWithIdentifier("order") as? OrderCell
        
        if(cell == nil) {
            cell = OrderCell(style: UITableViewCellStyle.Default, reuseIdentifier: "order")
        }
        
        let order = orders[indexPath.row]
        
        var customer: Person? = order.customer
        
        if customer != nil {
            cell!.topLeftLabel?.text = customer!.name
        } else {
            cell!.topLeftLabel?.text = "Customer"
        }
        
        let products: [ProductD] = order.products.allObjects as! [ProductD]
        
        var bodyText = ""
        for product in products {
                bodyText = ("\(bodyText) \(product.productName) (\(product.quantity))")
        }
        cell!.bodyLabel?.text = bodyText
        
        cell!.topRightLabel?.text = order.orderDate
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let order = orderDao.getOrders()[indexPath.row]
        
        var destViewController: AddOrderViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddOrderViewController") as! AddOrderViewController
    
        if(indexPath.row >= 0) {
            destViewController.order = order
        }
        self.presentViewController(destViewController, animated: true, completion: nil)
        
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let selectedOrder = orders[indexPath.row] as OrderD
            orderDao.deleteOrder(selectedOrder)
            orders.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            appDel.saveContextAction()
        }
    }



}

