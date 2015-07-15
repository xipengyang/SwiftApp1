//
//  StockD.swift
//  we sale assistant
//
//  Created by xipeng yang on 6/06/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import Foundation
import CoreData

class StockD: NSManagedObject {

    @NSManaged var amount: NSDecimalNumber
    @NSManaged var desc: String
    @NSManaged var quantity: NSNumber?
    @NSManaged var supplier: String
    @NSManaged var product: ProductD

}
