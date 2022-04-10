//
//  UserListView.swift
//  vk.internship.photos.2022
//
//  Created by Ivan Vislov on 06.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI

class UserListViewModel: ObservableObject {
    
    @Published var users = [AppUser]()
    @Published var errorMessage = ""
    
    @Published var selectedItem: [String] = []
    @Published var selectedItemID: String = ""


    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let user = AppUser(data: data)
                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(.init(data: data))
                    }
                    
                })
            }
    }
}

struct UserListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = UserListViewModel()
    
    @State private var showSheet = false

    var body: some View {
        VStack {
            HStack {
                Text("All users")
                    .font(.largeTitle)
                    .bold()
                    .padding(.leading)
                Spacer()
            }
            ScrollView {
                Text(vm.errorMessage)
                ForEach(vm.users) { user in
                    HStack(spacing: 16) {
                        Button(action: {
                            showSheet = true
                        }, label: {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                            .stroke(Color(.label), lineWidth: 2)
                            )
                        })
                        .sheet(isPresented: $showSheet, content: {
                            ZStack {
                                Color.black
                                    .edgesIgnoringSafeArea(.all)
                                TabView() {
                                    ForEach(vm.users, id: \.self) { user in
                                        VStack(spacing: 15) {
                                            WebImage(url: URL(string: user.profileImageUrl))
                                                .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            Text(user.email)
                                                .foregroundColor(Color.white)
                                        }
                                    }
                                    
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                            }
                        })
                        Text(user.email)
                            .foregroundColor(Color(.label))
                        Spacer()
                    }.padding(.horizontal)
                    Divider()
                        .padding(.vertical, 8)
                }
            }
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

