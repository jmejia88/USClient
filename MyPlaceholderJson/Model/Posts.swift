//
//  Posts.swift
//  MyPlaceholderJson
//
//  Created by iOS Development on 10/16/21.
//

import Foundation

struct Posts : Codable {
    
    let id: Int 
    let title: String
    let body: String
    let userId: Int
    
}

typealias PostsList = [Posts]
