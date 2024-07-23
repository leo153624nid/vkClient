import Kingfisher
import SwiftUI

public struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    public var body: some View {
        FeedView(viewModel: viewModel.feedViewModel)
            .background {
//              VkClientAsset.Colors.brand.swiftUIColor
                viewModel.backgroundColor
                    .ignoresSafeArea()
            }
            .onAppear {
                if !viewModel.isLoggedIn {
                    viewModel.perform(action: .showLoginView)
                }
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
