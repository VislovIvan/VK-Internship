//
//  AppUser.swift
//  vk.internship.photos.2022
//
//  Created by Ivan Vislov on 06.04.2022.
//

import Foundation

struct AppUser: Identifiable, Hashable {
    
    var id: String { uid }
    
    let uid, email, profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
