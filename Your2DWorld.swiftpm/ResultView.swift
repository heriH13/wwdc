//
//  File.swift
//  Your2DWorld
//
//  Created by heri hermawan on 20/04/22.
//

import SwiftUI

struct ResultView: View {
    
    @State var teks = "Do you like it ? \nYou may save the image ⭐️"
    @State var image: UIImage?
    @State private var showToast = false
    
    init(image : State<UIImage?>){
        _image = image
    }
    
    var body: some View{
        ZStack{
            Color.gray
                .ignoresSafeArea()
                .opacity(0.6)
            
            VStack{
                Image(uiImage: image!)
                    .resizable().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
                    .padding(.bottom, 10)
                VStack{
                    Text(teks)
                        .font(.body.bold().italic())
    //                    .foregroundStyle(.primary)
                    Button("🎞 Save Image"){
                        saveImage(image!)
                        withAnimation {
                            self.showToast.toggle()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }.padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 13))
            }
        }
        .toast(isPresented: $showToast){
            Text("Saved Successfully")
        }
        .navigationTitle("Result")
    }
    
    func saveImage(_ image : UIImage){
        guard let new = image.pngData() else { return }
        UIImageWriteToSavedPhotosAlbum(UIImage(data: new)!, self, #selector(NSObject.saveCompleted), nil)
    }
}

@objc
extension NSObject {
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//        self.showToast(message: "Saved Successfully", font: .systemFont(ofSize: 16.0))
        print("Saved !")
        }
}

extension View {
    func toast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View where Content: View {
        Toast(
            isPresented: isPresented,
            presenter: { self },
            content: content
        )
    }
}
