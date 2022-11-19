//
//  PostsListView.swift
//  IOS Concurrency
//
//  Created by Eric on 19/11/2022.
//

import SwiftUI

struct PostsListView: View {
    
    @StateObject var vm = PostsListViewModel()
    var userID: Int?
    
    var body: some View {
        List {
            ForEach(vm.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Posts")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .onAppear {
            vm.userId = userID
            vm.fetchPosts()
        }
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostsListView(userID: 1)
        }
    }
}
