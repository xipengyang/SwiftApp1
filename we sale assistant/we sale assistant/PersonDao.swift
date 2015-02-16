import UIKit
import CoreData

enum PersonType {
    case Customer
    case Supplier
}

struct Contact {
    var id:String!
    var name:String?
    var address:String?
    var phone:String?
    var weChatId:String?
    //var notes:String?
    var personType:String?
    
}


var personDao:PersonDao = PersonDao()

// This class acts as an in memory data store

class PersonDao: NSObject {
    
    private var contacts = [Contact]()
    
    var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate

    
    override init() {
        super.init()
        contacts = appDel.refreshContactAction()
    }
    
    
    func addPerson(name: String!, address: String? ,phone: String? ,weChatId: String? ,personType: String?) {
        
        let nextId = contacts.count + 1
        
        let newContact: Contact = Contact(id: String(nextId), name: name, address: address,phone: phone, weChatId: weChatId, personType: personType)
        
        contacts.append(newContact)
        
        appDel.savePersonAction(newContact)
        
    }
    
    func editPerson(id: String!, name: String!, address: String? ,phone: String? ,weChatId: String? ,personType: String?) {
        
        
        let contact: Contact = Contact(id: id, name: name, address: address,phone: phone, weChatId: weChatId, personType: personType)
        
        let index = id.toInt()!
        
        contacts[index] = contact
        
        appDel.savePersonAction(contact)
        
    }
    
    func setContacts(contactArray: [Contact]) {
        self.contacts = contactArray
    }
    
    
    func gerPersonAtIndex(index: Int) ->Contact {
        return contacts[index]
    }
    
    func getContacts() ->[Contact] {
        
        return contacts
    }
    
    
}
