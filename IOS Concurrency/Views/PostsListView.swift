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
        .overlay(
            Group {
                if vm.isLoading {
                    ProgressView()
                }
            }
        )
        .alert(isPresented: $vm.showAlert, content: {
            Alert(title: Text("Application Error"), message: Text(vm.errorMessage ?? ""))
        })
        .navigationTitle("Posts")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .onAppear {
            Task {
                vm.userId = userID
                await vm.fetchPosts()
            }
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
