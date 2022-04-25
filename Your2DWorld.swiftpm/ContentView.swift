import SwiftUI

struct ContentView: View {
    
    @State var isShown = false
    @State var originalImg : UIImage?
    @State var contouredImg : UIImage?
    @State var disableShowBtn = true
    @State var showResult = false
    @State var isProcessing = false
    @State private var showToast = false
    @State var btnTitle = "𑗋 Show Result"
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.gray
                    .ignoresSafeArea()
                    .opacity(0.6)
                Image(uiImage: UIImage.init(named: "BG2")!)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.7)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    .blur(radius: 3)
                
                VStack {
                    NavigationLink(destination: ResultView(image: _contouredImg), isActive: $showResult) { EmptyView() }
                    
                    VStack(alignment: .leading, spacing: 0){
                        Text("💡Tips :")
                            .font(.title.bold())
                        Text("For better results, place a white background behind the object or turn the camera flash on")
                            .font(.body.bold())
                    }.padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 13))
//                        .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .topLeading)
                    HStack{
                        Button("📷 Open Camera", action: { self.isShown.toggle()
                        })
                        .buttonStyle(.borderedProminent)
                        
                        Button($btnTitle.wrappedValue){
                            self.showResult.toggle()
                        }
                        .padding()
                        .disabled(disableShowBtn)
                        .buttonStyle(.borderedProminent)
        //                .navigate(to: ResultView(), when: $disableShowBtn)
                    }
                }
                .fullScreenCover(isPresented: $isShown){
                    CameraView(isShown: $isShown, disableShowBtn: $disableShowBtn, originalImg: $originalImg, contouredImg: $contouredImg, btnTitle: $btnTitle)
                }
                .navigationTitle("Your 2D World")
    //            .navigate(to: ResultView(), when: $showResult)
            }
        }
        .navigationViewStyle(.stack)
//        .toast(isPresented: $isProcessing){
//            Text("Processing your image")
//        }
    }
    
//    func setBtnTitle() -> String {
//        var title: String?
//
//        if($btnTitle.wrappedValue == "Processing the image"){
//            print("****** PROCESSING ")
//            title = "Processing the image"
//            return title!
//        }
//
//        return "𑗋 Show Result her"
//    }
}
