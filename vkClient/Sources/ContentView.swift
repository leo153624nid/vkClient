import SwiftUI
import Kingfisher
import VKID

public struct ContentView: View {
    private let vkid: VKID // TODO
    
    public init(vkid: VKID) {
        self.vkid = vkid
    }
    
    @State private var showLogin = false
    @State private var detentHeight: CGFloat = 0
    
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
//                .readHeight()
//                .onPreferenceChange(HeightPreferenceKey.self) { height in
//                    if let height {
//                        self.detentHeight = height
//                    }
//                }
//                .presentationDetents([.height(self.detentHeight)])
                .presentationDetents([.custom(MyCustomDetent.self)])
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
        // Return MyViewController instance
        let oneTapSheet = OneTapBottomSheet(
            serviceName: "Your service name",
            targetActionText: .signIn,
            oneTapButton: .init(
                height: .medium(.h44),
                cornerRadius: 8
            ),
            theme: .matchingColorScheme(.system),
            autoDismissOnSuccess: true
        ) { authResult in
            // authResult handling
        }
        let sheetViewController = vkid.ui(for: oneTapSheet).uiViewController()
        return sheetViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}





struct MyCustomDetent: CustomPresentationDetent {
    static func height(in context: Context) -> CGFloat? {
        if context.verticalSizeClass == .regular {
            return context.maxDetentValue * 0.3 // TODO
        } else {
            return context.maxDetentValue
        }
    }
}





struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat?

    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        guard let nextValue = nextValue() else { return }
        value = nextValue
    }
}

private struct ReadHeightModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: HeightPreferenceKey.self, value: geometry.size.height)
        }
    }

    func body(content: Content) -> some View {
        content.background(sizeView)
    }
}

extension View {
    func readHeight() -> some View {
        self
            .modifier(ReadHeightModifier())
    }
}
