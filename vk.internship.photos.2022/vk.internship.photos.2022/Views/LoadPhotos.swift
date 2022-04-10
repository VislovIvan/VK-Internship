//
//  LoadPhotos.swift
//  vk.internship.photos.2022
//
//  Created by Ivan Vislov on 09.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct LoadPhotos: View {
    
    @ObservedObject var RandomImages = getData()
    
    var body: some View {
        VStack {
            HStack {
                Text("Images from the internet")
                    .font(.title)
                    .bold()
            }
            if self.RandomImages.Images.isEmpty {
                
                Spacer()
                Indicator()
                Spacer()
                
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(self.RandomImages.Images, id: \.self) { i in
                            HStack(spacing: 20) {
                                ForEach(i) { j in
                                    AnimatedImage(url: URL(string: j.urls["thumb"]!))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 200)
                                        .cornerRadius(15)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct LoadPhotos_Previews: PreviewProvider {
    static var previews: some View {
        LoadPhotos()
    }
}

class getData : ObservableObject {
    
    @Published var Images : [[Photo]] = []
    
    init() {
        updateData()
    }
    
    func updateData() {
        let key = "scQNz-8l9_DtozKlkeXbnJJTSu9Jc9_P3CUS21Kkmmk"
        let url = "https://api.unsplash.com/photos/random/?count=30&client_id=\(key)"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            do {
                let json = try JSONDecoder().decode([Photo].self, from: data!)
                
                for i in stride(from: 0, to: json.count, by: 2) {
                    var ArrayData: [Photo] = []
                    
                    for j in i..<i+2 {
                        if j < json.count {
                            ArrayData.append(json[j])
                        }
                    }
                    DispatchQueue.main.async {
                        self.Images.append(ArrayData)
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
}

struct Photo: Identifiable, Decodable, Hashable {
    
    var id: String
    var urls: [String : String]
}

struct Indicator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
}
