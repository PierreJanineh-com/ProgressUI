# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Public memberwise initializer for ``Options``, allowing consumers to construct
  a configuration directly (e.g. `Options(progressColor: .blue)`) instead of
  only through the `set…` modifiers.
- Unit test target (`ProgressUITests`) covering `Options` defaults, the new
  initializer, `Progressable.calculate(from:)` bucketing, and `GrowDirection`
  alignment mapping.
- DocC catalog with a landing page and curated topics.
- DocC documentation published to GitHub Pages via a Documentation workflow
  (using `swift-docc-plugin`).
- Contribution guide, issue/PR templates, and a `CHANGELOG`.

### Changed
- CI now runs the test suite and builds across every supported platform
  (iOS, macOS, macCatalyst, watchOS, tvOS, visionOS), and avoids redundant
  runs (push builds `main` only; superseded runs are cancelled).

### Fixed
- Corrected the README "Dynamic Colors" and "Customization Options" examples,
  which previously did not compile.
