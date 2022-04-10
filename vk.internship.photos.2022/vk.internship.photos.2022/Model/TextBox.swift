//
//  TextBox.swift
//  vk.internship.photos.2022
//
//  Created by Ivan Vislov on 09.04.2022.
//

import SwiftUI
import PencilKit

struct TextBox: Identifiable {
    var id = UUID().uuidString
    var text: String = ""
    var isBold: Bool = false
    
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var textColor: Color = .white
    
    var isAdded: Bool = false
}

