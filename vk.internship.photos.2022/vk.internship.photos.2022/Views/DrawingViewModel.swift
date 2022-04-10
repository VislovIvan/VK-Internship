//
//  DrawingViewModel.swift
//  vk.internship.photos.2022
//
//  Created by Ivan Vislov on 09.04.2022.
//

import SwiftUI
import PencilKit

class DrawingViewModel: ObservableObject {
    @Published var showImagePicker = false
    @Published var imageData: Data = Data(count: 0)
    
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    
    @Published var textBoxes: [TextBox] = []
    @Published var addNextBox = false
    
    @Published var currentIndex: Int = 0
    
    @Published var rect: CGRect = .zero
    
    @Published var showAlert = false
    @Published var message = ""
    
    func cancelImageEditing() {
        imageData = Data(count: 0)
        canvas = PKCanvasView()
        textBoxes.removeAll()
    }
    
    func cancelTextView() {
        
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        
        withAnimation {
            addNextBox = false
        }
        
        if !textBoxes[currentIndex].isAdded {
            textBoxes.removeLast()
        }
    }
    
    func saveImage() {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let SwiftUIView = ZStack {
            ForEach(textBoxes) { [self] box in
                Text(textBoxes[currentIndex].id == box.id && addNextBox ? "" : box.text)
                    .font(.system(size: 30))
                    .fontWeight(box.isBold ? .bold : .none)
                    .foregroundColor(box.textColor)
                    .offset(box.offset)
                
            }
        }
        
        let controller = UIHostingController(rootView: SwiftUIView).view!
        controller.frame = rect
        
        controller.backgroundColor = .clear
        canvas.backgroundColor = .clear
        
        controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if let image = generatedImage?.pngData() {
            UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
            print("success")
            self.message = "Saved succesfully!"
            self.showAlert.toggle()
        }
    }
}


