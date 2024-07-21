import Kingfisher
import SwiftUI

public struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    public var body: some View {
        VStack {
            KFImage(URL(string: "https://cloud.tuist.io/images/tuist_logo_32x32@2x.png")!)
                .onTapGesture {
                    viewModel.perform(action: .showLoginView)
                }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
//            VkClientAsset.Colors.brand.swiftUIColor
            Color.red
                .ignoresSafeArea()
        }
        .sheet(isPresented: $viewModel.showLoginView) {
            VKLoginView(sheetViewController: viewModel.sheetViewController)
                .presentationDetents([.custom(VKLoginViewDetent.self)])
        }
    }
}

#Preview {
    MainView(viewModel: MainViewModel())
}
