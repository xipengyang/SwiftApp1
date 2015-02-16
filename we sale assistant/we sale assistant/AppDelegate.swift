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
    
    
    func saveAllContactAction() {
        let contacts = personDao.getContacts()
        
        println("save all contact action")
        
        for contact:Contact in contacts {
            self.savePersonAction(contact)
        }
        
        cdh.saveContext()
    }
    
    func savePersonAction(contact : Contact) {
        
        println("save person action")
        
        let personId = contact.id
        
        println("person to save - \(personId)")
        
        let predicate = NSPredicate(format: "id = \(personId)")
        
        var newRecord: Person = cdh.fetchOrNewEntityByPredicate("Person", predicate: predicate ) as Person
        
        newRecord.setValue(contact.id.toInt(), forKey: "id")
        newRecord.setValue(contact.name, forKey: "name")
        newRecord.setValue(contact.address, forKey: "address")
        newRecord.setValue(contact.phone, forKey: "phone")
        newRecord.setValue(contact.weChatId, forKey: "weChat_id")
        newRecord.setValue(contact.personType, forKey: "personType")
        
        cdh.saveContext()
    }
    
    
    
    func refreshContactAction()-> [Contact]{
        println("refresh contact action")
        
        var contacts = [Contact]()
        
        var fetchedData = cdh.getEntitiesSorted("Person")
        
        if let people = fetchedData as? [Person] {
            if(people.count > 0 ) {
                println("data found. begin loading data...")
                
                for person: Person in people {
                    
                    let contact  = Contact(id: person.id.stringValue, name: person.name, address: person.address, phone: person.phone, weChatId: person.weChat_id, personType: person.personType)
                    
                    println("append contact - \(contact.id) into array")
                    
                    contacts.append(contact)
                    
                }
                
            }
        }
        
        return contacts
        
    }


}

