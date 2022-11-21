//
//  UserAndPosts.swift
//  IOS Concurrency
//
//  Created by Eric on 20/11/2022.
//

import Foundation

struct UserAndPosts: Identifiable {
    
    var id = UUID()
    let user: User
    let posts: [Post]
    var numberOfPosts: Int {
        posts.count
    }
}
