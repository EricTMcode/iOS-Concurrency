//
//  UsersListViewModel.swift
//  IOS Concurrency
//
//  Created by Eric on 19/11/2022.
//

import Foundation

class UsersListViewModel: ObservableObject {
    
    @Published var users = [User]()
    
    // Add progressView() for users low connection to visually know what's going on.
    @Published var isLoading = false
    
    // To provide an alert to the user with the error case.
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    func fetchUsers() {
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        
        // Make isLoading true when we start fetching the data.
        isLoading.toggle()
        
        // As purpose to simulate a low connection.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            apiService.getJSON { (result: Result<[User], APIError>) in
                
                // Use Defer the will be executed after the data is retrived and processes, so we set isLoading back to false, on the main thread.
                defer {
                    DispatchQueue.main.sync {
                        self.isLoading.toggle()
                    }
                }
                switch result {
                case .success(let users):
                    DispatchQueue.main.async {
                        self.users = users
                    }
                case.failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
                    }
                }
            }
        }
    }
}

// INFO: Use to fetch the data localy with users and posts.json in the preview content, not for the final purpose of the app.
extension UsersListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.users = User.mockUsers
        }
    }
}
