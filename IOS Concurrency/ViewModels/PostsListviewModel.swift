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
    var userId: Int?
    
    func fetchPosts() {
        if let userId = userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            isLoading.toggle()
            apiService.getJSON { (result: Result<[Post], APIError>) in
                defer {
                    DispatchQueue.main.async {
                        self.isLoading.toggle()
                    }
                }
                switch result {
                case .success(let posts):
                    DispatchQueue.main.async {
                        self.posts = posts
                    }
                case .failure(let error):
                    print(error)
                }
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

