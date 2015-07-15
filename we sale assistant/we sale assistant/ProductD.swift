//
//  ProductD.swift
//  we sale assistant
//
//  Created by xipeng yang on 6/06/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import Foundation
import CoreData

class ProductD: NSManagedObject {

    @NSManaged var image: NSData?
    @NSManaged var price: NSDecimalNumber?
    @NSManaged var productName: String
    @NSManaged var quantity: NSNumber?
    @NSManaged var order: OrderD
    @NSManaged var stocks: NSSet

}
