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
    var personType:String?
    
}


var personDao:PersonDao = PersonDao()

// This class acts as an in memory data store

class PersonDao: NSObject {
    
    private var contacts = [Contact]()
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    
    func refreshContacts() {
        contacts = appDel.refreshContactAction()
    }
    
    func addPerson(name: String!, address: String? ,phone: String? ,weChatId: String? ,personType: String?) {
        
        let nextId = contacts.count + 1
        
        let newContact: Contact = Contact(id: String(nextId), name: name, address: address,phone: phone, weChatId: weChatId, personType: personType)
        
        contacts.append(newContact)
        
        appDel.savePersonAction(newContact)
        
    }
    
    func savePerson(id: String!, name: String!, address: String? ,phone: String? ,weChatId: String? ,personType: String?) {
        
        
        let contact: Contact = Contact(id: id, name: name, address: address,phone: phone, weChatId: weChatId, personType: personType)
        
        let index = id.toInt()! - 1
        
        contacts[index] = contact
        
        appDel.savePersonAction(contact)
        
    }
    
    func setContacts(contactArray: [Contact]) {
        self.contacts = contactArray
    }
    
    func deleteContacts(index: Int) {
        self.contacts.removeAtIndex(index)
    }
    
    
    func getPersonAtIndex(identifier: Int) ->Person? {
        return appDel.getPersonByIdAction(identifier).last
    }
    
    func getContacts() ->[Contact] {
        
        return contacts
    }
    
    func deletePerson(var person: Person) {
        appDel.deleteObjectAction(person)
    }
    
    
}
