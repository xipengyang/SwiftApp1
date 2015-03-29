//
//  ProductD.swift
//  we sale assistant
//
//  Created by xipeng yang on 21/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import Foundation
import CoreData

class ProductD: NSManagedObject {

    @NSManaged var image: NSData?
    @NSManaged var productName: String
    @NSManaged var quantity: String
    @NSManaged var price: String
    @NSManaged var order: we_sale_assistant.OrderD
    @NSManaged var stocks: NSSet

}
