import SwiftUI

@main
struct MyApp: App {
    @State var img = UIImage.init(named: "BG2")
    var body: some Scene {
        WindowGroup {
            ContentView()
//            ResultView(image: _img)
        }
    }
}
