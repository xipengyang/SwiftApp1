//
//  OrderDao.swift
//  we sale assistant
//
//  Created by xipeng yang on 7/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

struct Order {
    var orderId: Int?
    var name: String!
    var time: NSDate!
    var customerId: Int?
    var supplier: Int?
}

let orderDao = OrderDao()

class OrderDao: NSObject {
    
    var orders:[Order] = [Order]()
    var orderId: Int
    
    override init() {
        self.orderId = orders.count
    }
    
    func saveOrder(var pOrder: Order) {
        pOrder.orderId = self.orderId
        orders.append(pOrder)
        println("new order Id - \(pOrder.orderId!)")
        self.orderId = orders.count
    }
    
    // return all orders for a customer
    func getOrderForCustomer(customerId : Int) -> [Order] {
        var result:[Order] = [Order]()
        for order in orders {
            if(customerId == order.customerId) {
                result.append(order)
            }
        }
        return result
    }
    
   
}
