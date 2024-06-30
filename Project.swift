import ProjectDescription

let project = Project(
    name: "투두팡",
    organizationName: "team1os",
    packages: [
        .remote(
            url: "https://github.com/google/GoogleSignIn-iOS",
            requirement: .upToNextMajor(from: "7.0.0")),
        .remote(
            url: "https://github.com/firebase/firebase-ios-sdk",
            requirement: .upToNextMajor(from: "10.15.0")),
        .remote(
            url: "https://github.com/dkk/WrappingHStack",
            requirement: .upToNextMajor(from: "2.0.0")),
        .remote(
            url: "https://github.com/evgenyneu/keychain-swift",
            requirement: .branch("master")),
    ],
    targets: [
        Target(
            name: "투두팡",
            platform: .iOS,
            product: .app,
            bundleId: "com.team1os.teamplan",
            deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
            infoPlist: "teamplan/Info.plist",
            sources: ["teamplan/Sources/**"],
            resources: ["teamplan/Resources/**"],
            entitlements: "teamplan/teamplan.entitlements",
            scripts: [
                .pre(script: "${PROJECT_DIR}/teamplan/Tools/swiftgen config run --config \"${PROJECT_DIR}/teamplan/Resources/swiftgen.yml\"", name: "Gen")
            ],
            dependencies: [
                .package(product: "GoogleSignIn"),
                .package(product: "GoogleSignInSwift"),
                .package(product: "FirebaseAuth"),
                .package(product: "FirebaseFirestore"),
                .package(product: "FirebaseFirestoreSwift"),
                .package(product: "WrappingHStack"),
                .package(product: "KeychainSwift"),
            ]
        ),
    ]
)
