# Contributing to ProgressUI

Thanks for your interest in improving ProgressUI! This document covers the
essentials for contributing.

## Getting started

1. Fork the repository and create a feature branch off `develop`:
   ```bash
   git checkout -b feature/my-feature develop
   ```
2. Make your change.
3. Build and test:
   ```bash
   swift build
   swift test
   ```
4. For UI changes, run the sample app in `Example/Example.xcodeproj` (iOS,
   macOS, and watchOS targets are available) to verify behavior interactively.

## Project layout

- `Sources/ProgressUI/` — the library. Public API surface is `ProgressUI`,
  `Options`, `Progressable`, `Shape`, `GrowDirection`, and `ProgressSize`.
- `Tests/ProgressUITests/` — XCTest unit tests.
- `Example/` — multi-platform sample app.

## Guidelines

- **Platform availability.** The package supports iOS 14+, macOS 11+,
  macCatalyst 14+, watchOS 7+, tvOS 15+, and visionOS 1+. Any new API must be
  available on all of these.
- **Configuration flows through `Options`.** Prefer adding a field to `Options`
  (and a matching `set…` modifier) over adding new initializers to `ProgressUI`.
- **Public API is semver-relevant.** Treat changes to the public types above as
  breaking unless they are purely additive.
- **Document public API** with `///` or `/** */` doc comments, and update the
  DocC landing page (`Sources/ProgressUI/ProgressUI.docc/ProgressUI.md`) when
  adding new public symbols.
- **Add tests** for new logic where practical.
- **Update `CHANGELOG.md`** under `[Unreleased]`.

## Pull requests

Open pull requests against `develop`. CI builds and tests across all supported
platforms; please make sure it is green before requesting review.
