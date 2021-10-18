//
//  PostComments.swift
//  MyPlaceholderJson
//
//  Created by iOS Development on 10/17/21.
//

import Foundation

struct PostsComments : Codable {
    
    let id: Int
    let name: String
    let body: String
    let email: String
    let postId: Int
}

typealias PostsCommentsList = [PostsComments]
