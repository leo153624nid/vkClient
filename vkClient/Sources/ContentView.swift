import SwiftUI
import Kingfisher

public struct ContentView: View {
    public init() {}

    public var body: some View {
        VStack {
            KFImage(URL(string: "https://cloud.tuist.io/images/tuist_logo_32x32@2x.png")!)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            VkClientAsset.Colors.brand.swiftUIColor
                .ignoresSafeArea()
        }
    }
}


#Preview {
    ContentView()
}
