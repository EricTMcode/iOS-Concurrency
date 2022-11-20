//
//  PostsListviewModel.swift
//  IOS Concurrency
//
//  Created by Eric on 19/11/2022.
//

import Foundation

class PostsListViewModel: ObservableObject {
    
    @Published var posts = [Post]()
    @Published var isLoading = false
    // To provide an alert to the user with the error case.
    @Published var showAlert = false
    @Published var errorMessage: String?
    var userId: Int?
    
    @MainActor
    func fetchPosts() async {
        if let userId = userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            isLoading.toggle()
            defer {
                isLoading.toggle()
            }
            do {
                posts = try await apiService.getJSON()
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
            }
        }
    }
}

// INFO: Use to fetch the data localy with users and posts.json in the preview content, not for the final purpose of the app.
extension PostsListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.posts = Post.mockSingleUsersPostsArray
        }
    }
}

