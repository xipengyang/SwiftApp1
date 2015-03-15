//
//  StockD.swift
//  we sale assistant
//
//  Created by xipeng yang on 7/03/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import Foundation
import CoreData

class StockD: NSManagedObject {

    @NSManaged var quantity: String
    @NSManaged var supplier: String
    @NSManaged var amount: String
    @NSManaged var desc: String
    @NSManaged var product: we_sale_assistant.ProductD

}
