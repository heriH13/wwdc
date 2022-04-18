import SwiftUI
import Vision

struct ContentView: View{
    
    @State var points : String = ""
    @State var preProcessImage: UIImage?
    @State var contouredImage: UIImage?
    @State var showImagePicker: Bool = false
    @State var imageData : Image?
    var body: some View {
        VStack{
            Text("Contours: \(points)")

            Image("coins")
            .resizable()
            .scaledToFit()
                
            if let image = preProcessImage{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }

            if let image = contouredImage{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }

            Button("Detect Contours", action: {
                detectVisionContours()
            })
        }
    }
    
    func detectVisionContours(){
        let context = CIContext()
        let path = Bundle.main.path(forResource: "coin", ofType: "jpeg")
        if let sourceImage = UIImage.init(contentsOfFile: path!)
        {
            var inputImage = CIImage.init(cgImage: sourceImage.cgImage!)
            
            saveImage(sourceImage)
            
            let contourRequest = VNDetectContoursRequest.init()
            contourRequest.revision = VNDetectContourRequestRevision1
            contourRequest.contrastAdjustment = 1.0
            contourRequest.detectsDarkOnLight = true
            contourRequest.maximumImageDimension = 512

            let requestHandler = VNImageRequestHandler.init(ciImage: inputImage, options: [:])

            try! requestHandler.perform([contourRequest])
            let contoursObservation = contourRequest.results?.first
            
            self.points  = String(contoursObservation!.contourCount)
            self.contouredImage = drawContours(contoursObservation: contoursObservation!, sourceImage: sourceImage.cgImage!)

        } else {
            self.points = "Could not load image"
        }
    }
    
    func saveImage(_ image: UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }

    
    func capture(){
        
    }
    
}

public func drawContours(contoursObservation: VNContoursObservation, sourceImage: CGImage) -> UIImage {
    let size = CGSize(width: sourceImage.width, height: sourceImage.height)
    let renderer = UIGraphicsImageRenderer(size: size)
    
    let renderedImage = renderer.image { (context) in
    let renderingContext = context.cgContext

    let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
    renderingContext.concatenate(flipVertical)

    renderingContext.draw(sourceImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    
    renderingContext.scaleBy(x: size.width, y: size.height)
    renderingContext.setLineWidth(5.0 / CGFloat(size.width))
    let redUIColor = UIColor.red
    renderingContext.setStrokeColor(redUIColor.cgColor)
    renderingContext.addPath(contoursObservation.normalizedPath)
    renderingContext.strokePath()
    }
    
    return renderedImage
}
