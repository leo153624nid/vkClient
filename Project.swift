import ProjectDescription

let project = Project(
    name: "vkClient",
    targets: [
        .target(
            name: "vkClient",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.vkClient",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["vkClient/Sources/**"],
            resources: ["vkClient/Resources/**"],
            dependencies: [.external(name: "Kingfisher")]
        ),
        .target(
            name: "vkClientTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.vkClientTests",
            infoPlist: .default,
            sources: ["vkClient/Tests/**"],
            resources: [],
            dependencies: [.target(name: "vkClient")]
        ),
    ]
)
