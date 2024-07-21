import SwiftUI
import Kingfisher
import VKID

public struct ContentView: View {
    private let vkid: VKID // TODO
    
    public init(vkid: VKID) {
        self.vkid = vkid
    }
    
    @State private var showLogin = false
    
    public var body: some View {
        VStack {
            KFImage(URL(string: "https://cloud.tuist.io/images/tuist_logo_32x32@2x.png")!)
                .onTapGesture {
                    showLogin.toggle()
                }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
//            VkClientAsset.Colors.brand.swiftUIColor
            Color.red
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showLogin) {
            MyView(vkid: vkid)
                .presentationDetents([.custom(VKAuthViewDetent.self)])
//                .presentationDetents([.medium])
        }
    }
}


//#Preview {
//    ContentView(vkid: <#VKID#>)
//}

struct MyView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    private let vkid: VKID // TODO
    
    init(vkid: VKID) {
        self.vkid = vkid
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let oneTapSheet = OneTapBottomSheet(
            serviceName: "vkClient",
            targetActionText: .signIn,
            oneTapButton: .init(
                height: .medium(.h44),
                cornerRadius: 8
            ),
            theme: .matchingColorScheme(.system),
            autoDismissOnSuccess: true
        ) { authResult in
            // authResult handling // TODO
        }
        let sheetViewController = vkid.ui(for: oneTapSheet).uiViewController()
        
        return sheetViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
}





struct VKAuthViewDetent: CustomPresentationDetent {
    static func height(in context: Context) -> CGFloat? {
        if context.verticalSizeClass == .regular {
            return context.maxDetentValue * 0.35
        } else {
            return context.maxDetentValue
        }
    }
}
