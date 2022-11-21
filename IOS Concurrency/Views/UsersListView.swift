//
//  UsersListView.swift
//  IOS Concurrency
//
//  Created by Eric on 19/11/2022.
//

import SwiftUI

struct UsersListView: View {
    //#warning("remove the forPreview argument or set it to false before uploading to App Store")
    
    @StateObject var vm = UsersListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.users) { user in
                    NavigationLink {
                        PostsListView(userID: user.id)
                    } label: {
                        
                        
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.title)
                            Text(user.email)
                        }
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
            .navigationTitle("Users")
            .listStyle(.plain)
            .onAppear {
                Task {
                    await vm.fetchUsers()
                }
            }
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
    }
}
