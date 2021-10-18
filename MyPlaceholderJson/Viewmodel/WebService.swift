//
//  WebService.swift
//  MyPlaceholderJson
//
//  Created by iOS Development on 10/16/21.
//

import Foundation
import Combine
import SwiftUI
import CoreData

class WebService: ObservableObject {
    var didChange = PassthroughSubject<WebService,Never>()
    let persistenceController = PersistenceController.shared
    
    
    @Published var postList = PostsList(){
        didSet{
            didChange.send(self)
        }
    }
    
    @Published var postList2 = [PostsEntity()]{
        didSet{
            didChange.send(self)
        }
    }
    
    init(){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let response = response {
                print(response)
            }
            do{
                guard let data = data else { return }
                let posts = try JSONDecoder().decode(PostsList.self, from: data)
                self.SavePostsCoreData(postList: posts)
                //DispatchQueue.main.async {
                //    self.postList = posts
                //}
            }catch let error as NSError{
                print("API haven't wake up", error.localizedDescription)
            }
        }.resume()
    }
    
    func getPosts(){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let response = response {
                print(response)
            }
            do{
                guard let data = data else { return }
                let posts = try JSONDecoder().decode(PostsList.self, from: data)
                self.SavePostsCoreData(postList: posts)
                //DispatchQueue.main.async {
               //    self.postList = posts
               //}
            }catch let error as NSError{
                print("API haven't wake up", error.localizedDescription)
            }
        }.resume()
    }
    
    func SavePostsCoreData(postList:PostsList){
        
        let context = persistenceController.container.viewContext
        
        
        var counter = 1
        postList.forEach{ post in
            
            let object = fetchData(with: Int16(post.id))
            
            if(object.count == 0){
                let newPost = PostsEntity(context: context)
                newPost.id = Int16(post.id)
                newPost.userId = Int16(post.userId)
                newPost.body = post.body
                newPost.title = post.body
                if(counter > 20){
                    newPost.isRead = true
                }
            }
            
            counter += 1
        }
        
        do{
            try context.save()
            
        }catch{
            print("Error, ", error.localizedDescription)
        }
        
    }
    
    func fetchData(){
        let context = persistenceController.container.viewContext
        
        let fetchRequest: NSFetchRequest<PostsEntity>
        fetchRequest = PostsEntity.fetchRequest()

        // Fetch all objects of one Entity type
        
        do{
           let objects = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.postList2 = objects
            }
            
        }catch{
            print("Error, ", error.localizedDescription)
            
        }
        
        
    }
    
    func fetchData(with id:Int16) -> [PostsEntity]{
        let context = persistenceController.container.viewContext
                
        let fetchRequest: NSFetchRequest<PostsEntity>
        fetchRequest = PostsEntity.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        // Fetch all objects of one Entity type
        
        do{
           let objects = try context.fetch(fetchRequest)
            return objects
            
        }catch{
            print("Error, ", error.localizedDescription)
            return []
        }
        
        
    }
    
    func deleteAll() {
        let context = persistenceController.container.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "PostsEntity")
        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )
        
        deleteRequest.resultType = .resultTypeObjectIDs
        
        
        
        do{
            let batchDelete = try context.execute(deleteRequest)
                as? NSBatchDeleteResult
            
            guard let deleteResult = batchDelete?.result
                as? [NSManagedObjectID]
                else { return }
            
            let deletedObjects: [AnyHashable: Any] = [
                NSDeletedObjectsKey: deleteResult
            ]
            
            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: deletedObjects,
                into: [context]
            )
          
            
        }catch let error as NSError {
            print("Error", error.localizedDescription)
        }
    }
    
    func delete(with id: Int16) {
        let context = persistenceController.container.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "PostsEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )
        
        deleteRequest.resultType = .resultTypeObjectIDs
     
        
        do{
            let batchDelete = try context.execute(deleteRequest)
                as? NSBatchDeleteResult
            
            guard let deleteResult = batchDelete?.result
                as? [NSManagedObjectID]
                else { return }
            
            let deletedObjects: [AnyHashable: Any] = [
                NSDeletedObjectsKey: deleteResult
            ]
            
            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: deletedObjects,
                into: [context]
            )
          
            
        }catch let error as NSError {
            print("Error", error.localizedDescription)
        }
    }
}
