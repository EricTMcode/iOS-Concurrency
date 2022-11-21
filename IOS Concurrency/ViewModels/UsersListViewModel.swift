//
//  UsersListViewModel.swift
//  IOS Concurrency
//
//  Created by Eric on 19/11/2022.
//

import Foundation

class UsersListViewModel: ObservableObject {
    
    @Published var usersAndPosts = [UserAndPosts]()
    
    // Add progressView() for users low connection to visually know what's going on.
    @Published var isLoading = false
    
    // To provide an alert to the user with the error case.
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    @MainActor
    func fetchUsers() async {
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        let apiService2 = APIService(urlString: "https://jsonplaceholder.typicode.com/posts")
        
        // Make isLoading true when we start fetching the data.
        isLoading.toggle()
        defer {
            isLoading.toggle()
        }
        do {
            async let users: [User] = try await apiService.getJSON()
            async let posts: [Post] = try await apiService2.getJSON()
            let (fetchedUsers, fetchedPosts) = await (try users, try posts)
            for user in fetchedUsers {
                let userPosts = fetchedPosts.filter {$0.userId == user.id}
                let newUserAndPosts = UserAndPosts(user: user, posts: userPosts)
                usersAndPosts.append(newUserAndPosts)
            }
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
        }
    }
}

// INFO: Use to fetch the data localy with users and posts.json in the preview content, not for the final purpose of the app.
extension UsersListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.usersAndPosts = UserAndPosts.mockUsersAndPosts
        }
    }
}
