//
//  AppDelegate.swift
//  we sale assistant
//
//  Created by xipeng yang on 6/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var cdh: CoreDataHelper = {
        let cdh = CoreDataHelper()
        return cdh
    }()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //WXApi.registerApp("wx1023fe6e2606945c")
        //UINavigationBar.appearance().barTintColor  = UIColor.orangeColor()
        //UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.cdh.saveContext()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.cdh.saveContext()
    }
    
    func savePersonAction(contact : Contact) {
        
        print("save person action")
        
        let personId = contact.id
        
        print("person to save - \(personId)")
        
        let predicate = NSPredicate(format: "id = \(personId)")
        
        let newRecord: Person = cdh.getOrNewEntityByPredicate("Person", predicate: predicate ) as! Person
        
        newRecord.setValue(Int(contact.id), forKey: "id")
        newRecord.setValue(contact.name, forKey: "name")
        newRecord.setValue(contact.address, forKey: "address")
        newRecord.setValue(contact.phone, forKey: "phone")
        newRecord.setValue(contact.weChatId, forKey: "weChatId")
        newRecord.setValue(contact.personType, forKey: "personType")
        
        cdh.saveContext()
    }
    
    func getPersonByIdAction(identifier: Int) -> [Person] {
         print("get person for id \(identifier) action")
   
        let predicate: NSPredicate = NSPredicate(format: "id == \(identifier)")
        
        return cdh.getEntityByPredicate("Person", predicate: predicate) as! [Person]
        
    }
    
    func saveContextAction() {
        print("save context action")
        cdh.saveContext()
    }
    
    func newOrderAction() -> OrderD {
        print("new order action")
        
        return cdh.newEntity("OrderD") as! OrderD
    }
    
    func newProductAction() -> ProductD {
        print("new product action")
        
        return cdh.newEntity("ProductD") as! ProductD
    }
    
    func newStockAction() -> StockD {
        print("new stock action")
        
        return cdh.newEntity("StockD") as! StockD
    }
    
    func saveProductAction(product : ProductD) {
        
        print("save product action \(product)")
        
        cdh.saveContext()
    }
    
    func deleteObjectAction(object: NSManagedObject) {
        print("delecte object action \(object)")
        
        cdh.deleteObject(object)
    }
    
    
    func refreshContactAction()-> [Contact]{
        print("refresh contact action")
        
        var contacts = [Contact]()
        
        let fetchedData = cdh.getEntities("Person")
        
        if let people = fetchedData as? [Person] {
            if(people.count > 0 ) {
                print("data found. begin loading data...")
                for person: Person in people {
                    let contact  = Contact(id: person.id!.stringValue, name: person.name, address: person.address, phone: person.phone, weChatId: person.weChatId, personType: person.personType)
                    print("append contact - \(contact.id) into array")
                    contacts.append(contact)
                }
            }
        }
        return contacts
    }
    
    func refreshOrderAction()-> [OrderD] {
        print("refresh order action")
        
        let fetchedData = cdh.getEntities("OrderD")
        
        if (fetchedData.count > 0) {
            for order: OrderD in fetchedData as! [OrderD] {
                print("found order data \(order) ")
            }
            return fetchedData as! [OrderD]
        }
        
        print("no order found. so return empty array")
        return [OrderD]()
    }
    
    func getProductStockAction()-> [ProductD] {
        print("get product stock action")
        
        let predicate: NSPredicate = NSPredicate(format: "order.status == 'New' ")
        
        let fetchedData = cdh.getEntityByPredicate("ProductD",predicate: predicate)
        
        if (fetchedData.count > 0) {
            for product: ProductD in fetchedData as! [ProductD] {
                print("found product data \(product) ")
            }
            return fetchedData as! [ProductD]
        }
        
        print("no product found. so return empty array")
        return [ProductD]()
    }
    
    
    func rollbackAction() {
        print("rollback context action")
        cdh.rollbackContext()
        
    }


}

