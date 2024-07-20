import ProjectDescription

let vk_client_id = "52017937" // TODO
let infoPlist = InfoPlist.extendingDefault(
    with: [
        "UILaunchScreen": [
            "UIColorName": "Brand",
            "UIImageName": "",
        ],
        "LSApplicationQueriesSchemes": ["vkauthorize-silent"],
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLName": "auth_callback",
                "CFBundleURLSchemes": ["\(vk_client_id)"]
            ]
        ]
    ]
)

let project = Project(
    name: "vkClient",
    targets: [
        .target(
            name: "vkClient",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.vkClient",
            infoPlist: infoPlist,
            sources: ["vkClient/Sources/**"],
            resources: ["vkClient/Resources/**"],
            dependencies: [
                .external(name: "Kingfisher"),
                .external(name: "VKID"),
            ]
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
