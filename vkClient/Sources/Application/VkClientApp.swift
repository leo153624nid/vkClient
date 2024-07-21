import SwiftUI

@main
struct VkClientApp: App {
    @Shared private var environment = createEnvironment()
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel())
        }
    }
    
    private static func createEnvironment() -> ServiceContainer {
        return ProductEnvironment()
    }
    
}
