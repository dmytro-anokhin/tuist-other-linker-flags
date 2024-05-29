# tuist-other-linker-flags
Showcase for mergeable libraries overriding other linker flags: https://github.com/tuist/tuist/issues/6349

---

### What happened?

Using `MergedBinaryType.manual` overrides Other Linker Flags. Flags provided using `xcconfig` file. `Project.swift` like this:

```
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
            // ...
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
            // ...
            settings: settings,
            mergeable: true
        ),
    ],
    // ...
)
```

### How do we reproduce it?

Use the sample project: https://github.com/dmytro-anokhin/tuist-other-linker-flags

1. `tuist generate`;
2. Check Other Linker Flags.

Result:

```
//:configuration = Debug
OTHER_LDFLAGS = -Wl,-reexport_framework,Framework
//:configuration = Release
OTHER_LDFLAGS = -Wl,-merge_framework,Framework
```

Expected:

```
//:configuration = Debug
OTHER_LDFLAGS = -ObjC -Wl,-reexport_framework,Framework
//:configuration = Release
OTHER_LDFLAGS = -ObjC -Wl,-merge_framework,Framework
```


### Error log

None

### macOS version

14.5

### Tuist version

4.15.0

### Xcode version

15.3
