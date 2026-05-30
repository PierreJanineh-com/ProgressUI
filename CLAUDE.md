# ProgressUI

SwiftUI library providing a customizable circular/linear progress indicator. Distributed as a Swift Package (SPM).

## Build & verify

```bash
swift build                    # build the library
swift build -c release         # release build
xcodebuild -scheme ProgressUI -destination 'platform=iOS Simulator,name=iPhone 15' build
```

There is no test target. To exercise changes interactively, open `Example/Example.xcodeproj` (iOS/macOS/watchOS targets) and run the `Example` scheme.

## Layout

- `Package.swift` — single library target `ProgressUI`. Supports iOS 14+, macOS 11+, macCatalyst 14+, watchOS 7+, tvOS 15+, visionOS 1+. Any new API must be available on all of these.
- `Sources/ProgressUI/`
  - `Components/ProgressUI/` — public entry point.
    - `ProgressUI.swift` — the `ProgressUI` SwiftUI `View`.
    - `ProgressUI+Modifiers.swift` — fluent `.option(...)` style modifiers.
    - `ProgressUI+ViewModel.swift` — internal observable state.
  - `Components/BaseProgress.swift` — shared shape/animation scaffolding.
  - `Components/CircularProgress.swift`, `LinearProgress.swift` — the two `Shape` implementations selected via `Options.shape`.
  - `Options.swift` — the single configuration struct passed into `ProgressUI`.
  - `Progressable.swift` — protocol consumers implement to drive dynamic coloring (`color`, optional `innerColor`, `calculate(from:)`).
  - `Shape.swift`, `GrowDirection.swift`, `ProgressSize.swift` — small enums used by `Options`.
- `Example/` — multi-platform sample app demonstrating usage.

## Conventions

- Public API surface is `ProgressUI`, `Options`, `Progressable`, `Shape`, `GrowDirection`, `ProgressSize`. Treat changes to these as semver-relevant.
- Configuration flows through `Options` — prefer adding a field there over adding new initializers on `ProgressUI`.
- State-driven coloring is opt-in via the generic `statusType:` parameter taking a `Progressable.Type`.
- Keep view-extension files (`ProgressUI+*.swift`) split by concern rather than collapsing into the main view file.
