//
//  PostsEntity+CoreDataProperties.swift
//  MyPlaceholderJson
//
//  Created by iOS Development on 10/17/21.
//
//

import Foundation
import CoreData


extension PostsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostsEntity> {
        return NSFetchRequest<PostsEntity>(entityName: "PostsEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var userId: Int16
    @NSManaged public var posts_comments: NSSet?
    @NSManaged public var isRead: Bool
    @NSManaged public var isFavorite: Bool

}

// MARK: Generated accessors for posts_comments
extension PostsEntity {

    @objc(addPosts_commentsObject:)
    @NSManaged public func addToPosts_comments(_ value: CommentsEntity)

    @objc(removePosts_commentsObject:)
    @NSManaged public func removeFromPosts_comments(_ value: CommentsEntity)

    @objc(addPosts_comments:)
    @NSManaged public func addToPosts_comments(_ values: NSSet)

    @objc(removePosts_comments:)
    @NSManaged public func removeFromPosts_comments(_ values: NSSet)

}

extension PostsEntity : Identifiable {
    
    
}
