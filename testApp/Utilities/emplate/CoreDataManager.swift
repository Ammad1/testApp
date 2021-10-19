//
//  CoreDataManager.swift
//  testApp
//
//  Created by Ammad Tariq on 12/10/2021.
//

import Foundation
import CoreData

//MARK: - Enums
enum EntityName: String {
    case User
    case Notes
    case ProfileViewed
}

class CoreDataManager {
    
    //MARK: - Properties
    static let shared = CoreDataManager()
    
    var context: NSManagedObjectContext {
        return CoreDataManager.shared.persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "testApp")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Helper Methods
    private func saveContext (_ completion: (()->())? = nil) {
        DispatchQueue.main.async {
            if self.context.hasChanges {
                do {
                    try self.context.save()
                    completion?()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}

//MARK: - User Entity Methods
extension CoreDataManager {
    
    func saveUser(_ userData: User) {
        DispatchQueue.main.async {
            let userEntity = NSEntityDescription.entity(forEntityName: EntityName.User.rawValue, in: self.context)!
            let user = NSManagedObject(entity: userEntity, insertInto: self.context)
            user.setValue(userData.login, forKey: "login")
            user.setValue(userData.id, forKey: "id")
            user.setValue(userData.nodeId, forKey: "nodeId")
            user.setValue(userData.avatarUrl, forKey: "avatarUrl")
            user.setValue(userData.avatarId, forKey: "avatarId")
            user.setValue(userData.url, forKey: "url")
            user.setValue(userData.htmlUrl, forKey: "htmlUrl")
            user.setValue(userData.followersUrl, forKey: "followersUrl")
            user.setValue(userData.followingUrl, forKey: "followingUrl")
            user.setValue(userData.gistsUrl, forKey: "gistsUrl")
            user.setValue(userData.starredUrl, forKey: "starredUrl")
            user.setValue(userData.subscriptionsUrl, forKey: "subscriptionsUrl")
            user.setValue(userData.organizationsUrl, forKey: "organizationsUrl")
            user.setValue(userData.reposUrl, forKey: "reposUrl")
            user.setValue(userData.eventsUrl, forKey: "eventsUrl")
            user.setValue(userData.receivedEventsUrl, forKey: "receivedEventsUrl")
            user.setValue(userData.type, forKey: "type")
            user.setValue(userData.siteAdmin, forKey: "siteAdmin")
            
            self.saveContext()
        }
    }
    
    func saveUsers(_ users: [User]) {
        
        for userData in users {
            saveUser(userData)
        }
    }
    
    func retrieveAllUsers() -> [User] {
        var users = [User]()
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.User.rawValue)
            
            do {
                
                if let result = try self.context.fetch(fetchRequest) as? [NSManagedObject] {
                    
                    
                    for data in result {
                        var user = User()
                        user.login = data.value(forKey: "login") as? String
                        user.id = data.value(forKey: "id") as? Int
                        user.nodeId = data.value(forKey: "nodeId") as? String
                        user.avatarUrl = data.value(forKey: "avatarUrl") as? String
                        user.avatarId = data.value(forKey: "avatarId") as? String
                        user.url = data.value(forKey: "url") as? String
                        user.htmlUrl = data.value(forKey: "htmlUrl") as? String
                        user.followersUrl = data.value(forKey: "followersUrl") as? String
                        user.followingUrl = data.value(forKey: "followingUrl") as? String
                        user.gistsUrl = data.value(forKey: "gistsUrl") as? String
                        user.starredUrl = data.value(forKey: "starredUrl") as? String
                        user.subscriptionsUrl = data.value(forKey: "subscriptionsUrl") as? String
                        user.organizationsUrl = data.value(forKey: "organizationsUrl") as? String
                        user.reposUrl = data.value(forKey: "reposUrl") as? String
                        user.eventsUrl = data.value(forKey: "eventsUrl") as? String
                        user.receivedEventsUrl = data.value(forKey: "receivedEventsUrl") as? String
                        user.type = data.value(forKey: "type") as? String
                        user.siteAdmin = data.value(forKey: "siteAdmin") as? Bool
                        
                        users.append(user)
                    }
                }
                
            } catch {
                
                print("Failed")
            }
            users = users.sorted(by: {$0.id ?? 0 < $1.id ?? 1})
        }
        return users
    }
    
    func deleteAllUserData() {
        DispatchQueue.main.async {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName:EntityName.User.rawValue)
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            
            do {
                try self.context.execute(request)
                
            } catch {
                
                print("Failed")
            }
        }
    }
}

//MARK: - Notes Entity Methods
extension CoreDataManager {
    
    func saveNotes(forId id: Int?, _ data: String, completion: (()->())? = nil) {
        guard let userId = id else { return }
        
        DispatchQueue.main.async {
            let notesEntity = NSEntityDescription.entity(forEntityName: EntityName.Notes.rawValue, in: self.context)!
            let notes = NSManagedObject(entity: notesEntity, insertInto: self.context)
            notes.setValue(data, forKey: "note")
            notes.setValue(userId, forKey: "id")
            
            self.saveContext(completion)
        }
    }
    
    func updateNote(forId id: Int?, _ data: String, completion: (()->())? = nil) {
        guard let userId = id else { return }
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.Notes.rawValue)
            fetchRequest.predicate = NSPredicate(format: "id = %d", userId)
            do
            {
                if let result = try self.context.fetch(fetchRequest) as? [NSManagedObject] {
                    
                    for object in result {
                        object.setValue(data, forKey: "note")
                    }
                    self.saveContext(completion)
                }
                
            }
            catch
            {
                print(error)
            }
        }
        
    }
    
    func deleteNote(forId id: Int?, completion: (()->())? = nil) {
        guard let userId = id else { return }
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.Notes.rawValue)
            fetchRequest.predicate = NSPredicate(format: "id = %d", userId)
            
            do
            {
                if let result = try self.context.fetch(fetchRequest) as? [NSManagedObject] {
                    for data in result {
                        self.context.delete(data)
                    }
                }
                
                self.saveContext(completion)
                
            }
            catch
            {
                print(error)
            }
        }
    }
    
    func retrieveNotes(forId id: Int?, completion: ((String)->())? = nil) {
        var noteValue = ""
        guard let userId = id else { return }
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.Notes.rawValue)
            
            fetchRequest.predicate = NSPredicate(format: "id = %d", userId)
            
            do {
                if let result = try self.context.fetch(fetchRequest) as? [NSManagedObject] {
                    for data in result {
                        noteValue = data.value(forKey: "note") as? String ?? ""
                    }
                }
                completion?(noteValue)
                
            } catch {
                print("Failed")
            }
        }
        
    }
    
}

//MARK: - Profile Entity Methods
extension CoreDataManager {
    
    func profileViewed(withUserId id: Int?, completion: @escaping ()->()) {
        guard let userId = id else {
            return
        }
        
        isProfileViewed(withUserId: id) { isViewed in
            if isViewed == false {
                DispatchQueue.main.async {
                    let profileEntity = NSEntityDescription.entity(forEntityName: EntityName.ProfileViewed.rawValue, in: self.context)!
                    let profile = NSManagedObject(entity: profileEntity, insertInto: self.context)
                    profile.setValue(userId, forKey: "id")
                    
                    self.saveContext()
                    completion()
                }
            }
        }
    }
    
    func isProfileViewed(withUserId id: Int?, completion: @escaping (_ isViewed: Bool)->()) {
        guard let userId = id else { return }
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.ProfileViewed.rawValue)
            
            fetchRequest.predicate = NSPredicate(format: "id = %d", userId)
            
            do {
                let result = try self.context.fetch(fetchRequest) as? [NSManagedObject]
                let isViewed = (result?.count ?? 0) > 0
                completion(isViewed)
                
            } catch {
                print("Failed")
            }
        }
    }
}
