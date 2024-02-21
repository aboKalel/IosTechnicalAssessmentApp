//
//  Users+CoreDataProperties.swift
//  IosTechnicalAssessmentApp
//
//  Created by Ibrahim on 10/08/1445 AH.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }
    @NSManaged public var id: Int
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var status: String?

}

extension Users : Identifiable {

}

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Userslist")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
