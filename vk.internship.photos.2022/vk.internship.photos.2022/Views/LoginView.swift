//
//  LoginView.swift
//  vk.internship.photos.2022
//
//  Created by Ivan Vislov on 05.04.2022.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    let didCompleteLoginProcess: () -> ()
    
    @State private var isLoginMode = false
    @State private var email = ""
    @State private var password = ""
    @State private var shouldShowImagePicker = false
    
    @State private var alertFailAccount = false
    @State private var alertFailAvatar = false
    @State private var alertFailLogIn = false
    @State private var alertFailImage = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                        .stroke(Color.black, lineWidth: 3))
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).stroke(.gray.opacity(0.7), lineWidth: 2))
                    .background(Color.gray.opacity(0.01))
                    .cornerRadius(5)
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }
                        .background(Color.blue)
                        .cornerRadius(5)
                    }
                    .alert(self.loginStatusMessage, isPresented: $alertFailAvatar) {
                        Button("OK", role: .cancel) { }
                    }
                    .alert(self.loginStatusMessage, isPresented: $alertFailAccount) {
                        Button("OK", role: .cancel) { }
                    }
                    .alert(self.loginStatusMessage, isPresented: $alertFailLogIn) {
                        Button("OK", role: .cancel) { }
                    }
                    .alert(self.loginStatusMessage, isPresented: $alertFailImage) {
                        Button("OK", role: .cancel) { }
                    }
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
                .ignoresSafeArea()
        }
    }
    
    @State var image: UIImage?
    
    private func handleAction() {
        if isLoginMode {
            //            print("Should log into Firebase with existing credentials")
            loginUser()
        } else {
            createNewAccount()
            //            print("Register a new account inside of Firebase Auth and then store image in Storage somehow")
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to login user:", err)
                alertFailLogIn = true
                self.loginStatusMessage = "Failed to login user"
                return
            }
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            self.loginStatus = "Successfully logged!"
            self.didCompleteLoginProcess()
        }
    }
    
    @State var loginStatusMessage = ""
    @State var loginStatus = ""
    
    private func createNewAccount() {
        if self.image == nil {
            alertFailAvatar = true
            self.loginStatusMessage = "You must select an avatar image!"
            return
        }
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                alertFailAccount = true
                print("Failed to create user!")
                self.loginStatusMessage = "Failed to create user!"
                return
            }
            print("Successfully created user: \(result?.user.uid ?? "")")
            self.loginStatus = "Successfully created user!"
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                alertFailImage = true
                self.loginStatusMessage = "Failed to add image!"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                print(url?.absoluteString)
                
                guard let url = url else { return }
                self.storeUserInformation(imageProfileUrl: url)
            }
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                print("Success")
                self.didCompleteLoginProcess()
            }
    }
}

struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        LoginView(didCompleteLoginProcess: {
            
        })
    }
}
