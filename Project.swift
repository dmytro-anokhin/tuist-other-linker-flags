import ProjectDescription

let settings: Settings = .settings(
    base: [
        "PROJECT_BASE": "PROJECT_BASE",
    ],
    configurations: [
        .debug(name: "Debug", xcconfig: "Support/Debug.xcconfig"),
        .release(name: "Release", xcconfig: "Support/Release.xcconfig"),
    ]
)

let project = Project(
    name: "App",
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "org.danokhin.tuist-mergeable-libraries.app",
            infoPlist: "Info.plist",
            sources: "App/**",
            dependencies: [
                .target(name: "Framework"),
            ],
            settings: settings,
            mergedBinaryType: .manual(mergeableDependencies: ["Framework"])
        ),
        .target(
            name: "Framework",
            destinations: .iOS,
            product: .framework,
            bundleId: "org.danokhin.tuist-mergeable-libraries.framework",
            infoPlist: "Info.plist",
            sources: "Framework/**",
            dependencies: [
            ],
            settings: settings,
            mergeable: true
        ),
    ],
    schemes: [
        .scheme(
            name: "AppCustomScheme",
            buildAction: .buildAction(targets: [TargetReference("App")])
        ),
    ]
)
