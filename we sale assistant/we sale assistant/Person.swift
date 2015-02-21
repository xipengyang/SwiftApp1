//
//  we_sale_assistant.swift
//  we sale assistant
//
//  Created by xipeng yang on 21/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var address: String
    @NSManaged var name: String
    @NSManaged var notes: String
    @NSManaged var personType: String
    @NSManaged var phone: String
    @NSManaged var weChat_id: String
    @NSManaged var order: NSSet

}
