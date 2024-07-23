import SwiftUI

@main
struct VkClientApp: App {
    @Shared private var environment = createEnvironment()
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    private let viewModel = MainViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: viewModel)
        }
    }
    
    private static func createEnvironment() -> ServiceContainer {
        return ProductEnvironment()
    }
    
}
