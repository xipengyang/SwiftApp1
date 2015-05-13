//
//  OrderD.swift
//  we sale assistant
//
//  Created by xipeng yang on 21/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import Foundation
import CoreData

class OrderD: NSManagedObject {

    @NSManaged var orderDate: String?
    @NSManaged var customer: we_sale_assistant.Person?
    @NSManaged var products: NSSet
    @NSManaged var status: String?

}
