//
//  UsersListViewModel.swift
//  IosTechnicalAssessmentApp
//
//  Created by Ibrahim on 10/08/1445 AH.
//

import Foundation
import SwiftUI
import CoreData
class ViewModel: ObservableObject {

    func getUsers(completion:@escaping (UsersResponse) -> ()) {
        let usersUrl = URL(string: "https://gorest.co.in/public-api/users")!
        URLSession.shared.dataTask(with: usersUrl) { data,_,_  in
            guard let data = data else {return}
            let users = try! JSONDecoder().decode(UsersResponse.self, from: data)
            
            DispatchQueue.main.async {
                completion(users)
            }
        }
        .resume()
    }
    
    func fetchUsers( viewContext: NSManagedObjectContext) -> [UserData] {
        let managedObjectContext = viewContext
        let request = NSFetchRequest<Users>(entityName: "Users")

        do {
            let items = try managedObjectContext.fetch(request)
            return items.map { user in
                return UserData(id: user.id, name: user.name, email: user.email, gender: nil, status: user.status == Status.active.rawValue ? .active : .inactive)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func updateOrCreateItem(user: UserData, viewContext: NSManagedObjectContext) {
        // Fetch the item if it exists
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        guard let id = user.id else {return}
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let items = try viewContext.fetch(fetchRequest)
            if let existingItem = items.first {
                // Update existing item
                existingItem.name = user.name
                existingItem.email = user.email
                existingItem.status = user.status?.rawValue
            } else {
                // Create new item
                let newItem = Users(context: viewContext)
                newItem.id = id
                newItem.name = user.name
                newItem.email = user.email
                newItem.status = user.status?.rawValue
            }
            
            // Save changes to the managed object context
            try viewContext.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func saveUsers(userseList: [UserData], viewContext: NSManagedObjectContext) {
        for user in userseList {
            updateOrCreateItem(user: user, viewContext: viewContext)
        }

    }
    
}
extension Notification.Name {
    
    public static let receiveMessage = Notification.Name("receiveMessage")
}
