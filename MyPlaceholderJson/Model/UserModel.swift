//
//  UserModel.swift
//  MyPlaceholderJson
//
//  Created by iOS Development on 10/17/21.
//

import Foundation

// MARK: - UserModel
struct UserModel: Codable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}

typealias UserInfo = [UserModel]
