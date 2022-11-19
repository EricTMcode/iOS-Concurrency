//
//  User.swift
//  IOS Concurrency
//
//  Created by Eric on 19/11/2022.
//

import Foundation

// Source: https://jsonplaceholder.typicode.com/users

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
}
