//
//  ProductViewController.swift
//  we sale assistant
//
//  Created by xipeng yang on 7/03/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        products.removeAll(keepCapacity: true)
        products = appDel.getProductStockAction()
        productTblView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let  cell:UITableViewCell = productTblView.dequeueReusableCellWithIdentifier("productStockCell") ?? UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "productStockCell")
        
        let product:ProductD = products[indexPath.row]
        let stocks = product.stocks.allObjects as! [StockD]
        var totalStock: Int = 0
        for stock in stocks {
            if let q = stock.quantity {
                totalStock = totalStock + q.integerValue
            }
        }
        cell.textLabel?.text = product.productName
        cell.detailTextLabel?.text = " Sold \(product.quantity)    Bought \(totalStock)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let productAtRow = products[indexPath.row]
        let dest: EditStockViewController = self.storyboard?.instantiateViewControllerWithIdentifier("editStockView") as! EditStockViewController!
        dest.product = productAtRow
        self.presentViewController(dest, animated: true, completion: nil)
    }

//    variables 
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var products:[ProductD] = [ProductD]()
    @IBOutlet weak var productTblView: UITableView!

    

}
