# ``ProgressUI``

A highly customizable circular and linear progress indicator for SwiftUI.

## Overview

`ProgressUI` renders determinate or indeterminate progress with dynamic,
state-driven coloring, multiple size presets, adjustable stroke widths and line
caps, and smooth animations. It runs on iOS, macOS, macCatalyst, watchOS, tvOS,
and visionOS.

```swift
import SwiftUI
import ProgressUI

struct ContentView: View {
    var body: some View {
        ProgressUI(progress: 0.5)
    }
}
```

Customize appearance either by passing an ``Options`` value or by chaining the
`set…` modifiers:

```swift
ProgressUI(progress: 0.5, options: Options(progressColor: .blue, isRounded: false))

ProgressUI(progress: 0.5)
    .setProgressColor(.blue)
    .setIsRounded(false)
```

Drive coloring from progress state by conforming a `CaseIterable` type to
``Progressable`` and passing it as `statusType:`.

## Topics

### Creating a progress indicator

- ``ProgressUI/ProgressUI``

### Configuration

- ``Options``
- ``ProgressSize``
- ``Shape``
- ``GrowDirection``

### Dynamic coloring

- ``Progressable``
