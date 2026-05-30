# ProgressUI

SwiftUI library providing a customizable circular/linear progress indicator. Distributed as a Swift Package (SPM).

## Build & verify

```bash
swift build                    # build the library
swift test                     # run the ProgressUITests suite
swift build -c release         # release build
xcodebuild -scheme ProgressUI -destination 'generic/platform=iOS Simulator' build
```

Unit tests live in `Tests/ProgressUITests/` (XCTest). To exercise UI changes interactively, open `Example/Example.xcodeproj` (iOS/macOS/watchOS targets) and run the `Example` scheme.

> If a bare `swift build`/`swift test` fails with an SDK/compiler mismatch (e.g. "failed to build module 'Darwin'… SDK is built with a different Swift version"), the `swift` on `PATH` is an older standalone toolchain (e.g. swiftly) that doesn't match the Xcode SDK. Run via Xcode's toolchain instead: `xcrun swift build` / `xcrun swift test`.

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

## Branching & releases (Git Flow)

- `main` — stable, release-only. Every commit on `main` corresponds to a tagged release; never commit feature work directly here.
- `develop` — the integration branch. All day-to-day work merges here first.
- `feature/*` — branch off `develop`, merge back into `develop` via PR. CI (build + test across all platforms) must be green before merge.
- `release/*` — cut from `develop` when preparing a version: bump the version, finalize `CHANGELOG.md`, then merge into both `main` (tagged) and `develop`.
- `hotfix/*` — branch off `main` for urgent fixes, merge into both `main` (tagged) and `develop`.
- Tag releases with semantic versions (`MAJOR.MINOR.PATCH`); public-API changes to the types above drive the version bump. Update `CHANGELOG.md` under `[Unreleased]` as you go.
- Open PRs against `develop` (not `main`).
