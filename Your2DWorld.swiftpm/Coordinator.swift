//
//  File.swift
//  Your2DWorld
//
//  Created by heri hermawan on 18/04/22.
//

import SwiftUI
import Vision
import CoreImage

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @Binding var isShown : Bool
    @Binding var originalImg : UIImage?
    @Binding var contouredImg : UIImage?
    @Binding var disableShowBtn : Bool
//    @Binding var isProcessing: Bool
    @Binding var btnTitle: String
    @State var points : String = ""
    
    init(isShown: Binding<Bool>, disableShowBtn: Binding<Bool>, originalImg : Binding<UIImage?>, contouredImg : Binding<UIImage?>, btnTitle: Binding<String>){
        _isShown = isShown
        _disableShowBtn = disableShowBtn
        _originalImg = originalImg
        _contouredImg = contouredImg
        _btnTitle = btnTitle
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
//        originalImg = image
//        isProcessing = true
        btnTitle = "Processing the image"
        isShown = false
        DispatchQueue.main.async {
            self.detectVisionContours(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
    
    func detectVisionContours(_ image: UIImage?) {
        if let sourceImage = image
        {
            let inputImage = CIImage.init(cgImage: sourceImage.cgImage!)
            
            let contourRequest = VNDetectContoursRequest.init()
            contourRequest.revision = VNDetectContourRequestRevision1
            contourRequest.contrastAdjustment = 2.5
            contourRequest.maximumImageDimension = 512

            let requestHandler = VNImageRequestHandler.init(ciImage: inputImage, options: [:])

            try! requestHandler.perform([contourRequest])
            let contoursObservation = contourRequest.results?.first
            
            points  = String(contoursObservation!.contourCount)
//            self.contouredImg = drawContours(contoursObservation: contoursObservation!, sourceImage: sourceImage.cgImage!)
            contouredImg = drawContours(contoursObservation: contoursObservation!, sourceImage: sourceImage.alpha(0).cgImage!)
            
//            isProcessing = false
            btnTitle = "𑗋 Show Result"
            disableShowBtn = false
        } else {
            points = "Could not load image"
        }
    }

    func drawContours(contoursObservation: VNContoursObservation, sourceImage: CGImage) -> UIImage {
        let size = CGSize(width: sourceImage.width, height: sourceImage.height)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let renderedImage = renderer.image { (context) in
        let renderingContext = context.cgContext

        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
        renderingContext.concatenate(flipVertical)

        renderingContext.draw(sourceImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        renderingContext.scaleBy(x: size.width, y: size.height)
        renderingContext.setLineWidth(5.0 / CGFloat(size.width))
        let orangeUIColor = UIColor.orange
        renderingContext.setStrokeColor(orangeUIColor.cgColor)
        renderingContext.addPath(contoursObservation.normalizedPath)
        renderingContext.strokePath()
        }
        
        return renderedImage
    }
}

extension UIImage{
    func alpha(_ a: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { (_) in
            draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: a)
        }
    }
//    func alpha(_ value:CGFloat) -> UIImage {
//            UIGraphicsBeginImageContextWithOptions(size, false, scale)
//            draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
//            let newImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return newImage!
//        }
}
