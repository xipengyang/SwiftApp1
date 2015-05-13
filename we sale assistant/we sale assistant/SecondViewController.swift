//
//  SecondViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 6/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //orderDao.load()
        //orders = orderDao.getOrders()
        //self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: OrderCell?
        cell = self.tableView.dequeueReusableCellWithIdentifier("order") as? OrderCell
        
        if(cell == nil) {
            cell = OrderCell(style: UITableViewCellStyle.Default, reuseIdentifier: "order")
        }
        configureCell(cell!, atIndexPath: indexPath)
        return cell!
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.name
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let order = fetchedResultsController.objectAtIndexPath(indexPath) as! OrderD
        var destViewController: AddOrderViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddOrderViewController") as! AddOrderViewController
        if(indexPath.row >= 0) {
            destViewController.order = order
        }
        self.presentViewController(destViewController, animated: true, completion: nil)
        
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let selectedOrder = fetchedResultsController.objectAtIndexPath(indexPath) as! OrderD
            orderDao.deleteOrder(selectedOrder)
            //orders.removeAtIndex(indexPath.row)
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            appDel.saveContextAction()
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    /* called:
    - when a new model is created
    - when an existing model is updated
    - when an existing model is deleted */
    func controller(controller: NSFetchedResultsController,
        didChangeObject object: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            case .Update:
                if let i = indexPath {
                let cell = tableView.cellForRowAtIndexPath(i) as! OrderCell
                configureCell(cell, atIndexPath: i)
                tableView.reloadRowsAtIndexPaths([i], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            default:
                return
            }
    }
    
    /* called last
    tells `UITableView` updates are complete */
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    func configureCell(cell: OrderCell,
        atIndexPath indexPath: NSIndexPath) {
            let order = fetchedResultsController.objectAtIndexPath(indexPath) as! OrderD
            var customer: Person? = order.customer
            if customer != nil {
                cell.topLeftLabel?.text = customer!.name
            } else {
                cell.topLeftLabel?.text = "Customer"
            }
            let products: [ProductD] = order.products.allObjects as! [ProductD]
            var bodyText = ""
            for product in products {
                bodyText = ("\(bodyText) \(product.productName) (\(product.quantity))")
            }
            cell.bodyLabel?.text = bodyText
            cell.topRightLabel?.text = order.orderDate
    }
    
    //variables
    //var orders: [OrderD] = [OrderD]()
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var _fetchedResultsController: NSFetchedResultsController?
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        [unowned self] in
        // return if already initialized
        if self._fetchedResultsController != nil {
            return self._fetchedResultsController!
        }
        let managedObjectContext = self.appDel.cdh.getContext()
        
        let entity = NSEntityDescription.entityForName("OrderD", inManagedObjectContext: managedObjectContext)
        let sectionSortDescriptor = NSSortDescriptor(key: "status", ascending: true)
        let req = NSFetchRequest()
        req.entity = entity
        req.sortDescriptors = [sectionSortDescriptor]
        
        /* NSFetchedResultsController initialization
        a `nil` `sectionNameKeyPath` generates a single section */
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: managedObjectContext, sectionNameKeyPath: "status", cacheName: nil)
        aFetchedResultsController.delegate = self
        self._fetchedResultsController = aFetchedResultsController
        
        // perform initial model fetch
        var e: NSError?
        if !self._fetchedResultsController!.performFetch(&e) {
            println("fetch error: \(e!.localizedDescription)")
            abort();
        }
        
        return self._fetchedResultsController!
    }()

}

