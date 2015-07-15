//
//  Person.swift
//  we sale assistant
//
//  Created by xipeng yang on 6/06/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

    @NSManaged var address: String?
    @NSManaged var id: NSNumber?
    @NSManaged var name: String
    @NSManaged var note: String?
    @NSManaged var personType: String?
    @NSManaged var phone: String?
    @NSManaged var weChatId: String?
    @NSManaged var orders: NSSet

}
