//
//  File.swift
//  Your2DWorld
//
//  Created by heri hermawan on 18/04/22.
//

import SwiftUI

struct CameraView{
    
    @Binding var isShown : Bool
    @Binding var originalImg : UIImage?
    @Binding var contouredImg : UIImage?
    @Binding var disableShowBtn: Bool
    @Binding var btnTitle: String
//    @Binding var isProcessing: Bool
    
    init(isShown: Binding<Bool>, disableShowBtn: Binding<Bool>, originalImg: Binding<UIImage?>, contouredImg: Binding<UIImage?>, btnTitle: Binding<String>) {
        _isShown = isShown
        _disableShowBtn = disableShowBtn
        _originalImg = originalImg
        _contouredImg = contouredImg
        _btnTitle = btnTitle
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, disableShowBtn: $disableShowBtn, originalImg: $originalImg, contouredImg: $contouredImg, btnTitle: $btnTitle)
    }
}

extension CameraView : UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = true
        return picker
        }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraView>) {
        
    }
}

extension UIImagePickerController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
}
