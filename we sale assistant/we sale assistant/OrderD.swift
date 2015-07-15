//
//  OrderD.swift
//  we sale assistant
//
//  Created by xipeng yang on 6/06/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import Foundation
import CoreData

class OrderD: NSManagedObject {

    @NSManaged var orderDate: NSDate
    @NSManaged var status: String
    @NSManaged var customer: Person?
    @NSManaged var products: NSSet

}
