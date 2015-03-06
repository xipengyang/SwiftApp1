//
//  OrderDao.swift
//  we sale assistant
//
//  Created by xipeng yang on 7/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

var orderDao:OrderDao = OrderDao()

class OrderDao: NSObject {
    
    var orders:[OrderD] = [OrderD]()
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    
    func deleteOrder(var pOrder: OrderD) {
        appDel.deleteObjectAction(pOrder)
    }
    
    func newOrder() -> OrderD {
        return appDel.newOrderAction()
    }
    
    func load() {
        orders.removeAll(keepCapacity: true)
        orders = appDel.refreshOrderAction()
    }
    
    // return all orders for a customer
    func getOrderForCustomer(customerId : Int) -> [OrderD] {
        var result:[OrderD] = [OrderD]()
        for order in orders {
            if(customerId == order.customer!.id) {
                result.append(order)
            }
        }
        return result
    }
    
    func getOrders() -> [OrderD] {
        return orders
    }
    
   
}
