//
//  DrawingHome.swift
//  vk.internship.photos.2022
//
//  Created by Ivan Vislov on 09.04.2022.
//

import SwiftUI

struct DrawingHome: View {
    
    @StateObject var model = DrawingViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    if let _ = UIImage(data: model.imageData) {
                        DrawingScreen()
                            .environmentObject(model)
                        
                            .toolbar(content: {
                                
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button(action: model.cancelImageEditing, label: {
                                        Image(systemName: "xmark")
                                    })
                                }
                            })
                    }
                    else {
                        Button(action: {model.showImagePicker.toggle()}, label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.black)
                                .frame(width: 50, height: 50)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.07), radius: 5, x: 5, y: 5)
                                .shadow(color: Color.black.opacity(0.07), radius: -5, x: -5, y: -5)
                        })
                    }
                }
                .navigationTitle("Image editor")
            }
            if model.addNextBox {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                
                TextField("Type here", text: $model.textBoxes[model.currentIndex].text)
                    .font(.system(size: 35, weight: model.textBoxes[model.currentIndex].isBold ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundColor(model.textBoxes[model.currentIndex].textColor)
                    .padding()
                
                HStack {
                    Button(action: {
                        model.textBoxes[model.currentIndex].isAdded = true
                        
                        model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                        model.canvas.becomeFirstResponder()
                        withAnimation {
                            model.addNextBox = false
                        }
                    }, label: {
                        Text("Add")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                    Spacer()
                    Button(action: model.cancelTextView, label: {
                        Text("Cancel")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                }
                .overlay(
                    HStack(spacing: 15) {
                        ColorPicker("", selection: $model.textBoxes[model.currentIndex].textColor)
                            .labelsHidden()
                        
                        Button(action: {
                            model.textBoxes[model.currentIndex].isBold.toggle()
                        }, label: {
                            Text(model.textBoxes[model.currentIndex].isBold ? "Normal" : "Bold")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                    }
                )
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .sheet(isPresented: $model.showImagePicker, content: {
            ImagePickerEdit(showPicker: $model.showImagePicker, imageData: $model.imageData)
        })
        .alert(isPresented: $model.showAlert, content: {
            Alert(title: Text("Message"), message: Text(model.message), dismissButton: .destructive(Text("Ok")))
        })
    }
}

struct DrawingHome_Previews: PreviewProvider {
    static var previews: some View {
        DrawingHome()
    }
}
