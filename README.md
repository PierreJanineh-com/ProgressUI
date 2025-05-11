# ProgressUI

[![](https://img.shields.io/endpoint?url=https://swiftpackageindex.com/api/packages/PierreJanineh-com/ProgressUI/badge?type=swift-versions)](https://swiftpackageindex.com/pierrejanineh-com/ProgressUI)
[![](https://img.shields.io/endpoint?url=https://swiftpackageindex.com/api/packages/PierreJanineh-com/ProgressUI/badge?type=platforms)](https://swiftpackageindex.com/pierrejanineh-com/ProgressUI)
[![](https://img.shields.io/github/v/release/PierreJanineh-com/ProgressUI)]()

<img src="./example.gif" alt="Example ProgressUI" width="400" />

`ProgressUI` is a SwiftUI package that provides a highly customizable circular progress indicator. It supports dynamic coloring based on progress states, multiple size options, and smooth animations, making it perfect for showing progress, loading states, or status indicators in your iOS, macOS, watchOS, visionOS, and tvOS applications.

## Features
- 🎨 Dynamic progress colors based on state
- 🔄 Spinner mode for loading states
- 📏 Multiple size options (small/large/custom)
- ⚡️ Smooth animations and transitions
- 🎯 Customizable track and progress colors
- 📐 Adjustable stroke widths
- 🔲 Round or square line caps

## Installation

### Swift Package Manager
Add the package by going to your Xcode project:
1. Select your project in the file navigator
2. Choose the project or target where you want to add the package
3. Go to the Package Dependencies tab
4. Click the `+` button
5. Search for `ProgressUI` using the repository URL:
    ```bash
    https://github.com/PierreJanineh-com/ProgressUI
    ```

## Usage
> Check out the full example in this [here](./Example).

### Basic Usage
``` swift
import SwiftUI
import ProgressUI

struct ContentView: View {
    var body: some View {
        ProgressUI(progress: 0.5)
    }
}
```

### Progress with Dynamic Colors
``` swift
enum StorageStatus: CaseIterable, Progressable {
    case safe
    case warning
    case critical
    case full
    
    var color: Color { innerColor.opacity(0.4) }
    
    // Optional: Add inner color for layered effect
    var innerColor: Color? {
        switch self {
        case .safe:     return .green
        case .warning:  return .yellow
        case .critical: return .orange
        case .full:     return .red
        }
    }
    
    static func calculate(from progress: CGFloat) -> Status {
        let level: CGFloat = CGFloat(1) / CGFloat(Status.allCases.count)
        
        return switch progress {
            case 0...level:                 Excellent
            case level...(level * 2):       Normal
            case (level * 2)...(level * 3): SemiNormal
            case (level * 3)...(level * 4): Bad
            case (level * 4)...(level * 5): Critical
            default:                        Danger
        }
    }
}

struct ContentView: View {
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        ProgressUI(
            progress: $progress,
            options: .init(isRounded: true),
            statusType: StorageStatus.self
        )
    }
}
```

### Loading Spinner
``` swift
struct LoadingView: View {
    var body: some View {
        ProgressUI(
            progress: .constant(1),
            options: .init(
                isSpinner: true,
                spinnerCycleDuration: 2,
                progressColor: .blue
            )
        )
    }
}
```

### Customization Options
``` swift
let options = Options(
    size: .large,             // Size preset
    trackColor: .gray,        // Color of the background track
    trackWidth: 45,           // Custom track width
    animationMaxValue: 0.06,  // Progress threshold for width animation
    animation: .easeInOut,    // Custom animation
    innerProgressWidth: 5,    // Width of inner progress line
    innerProgressColor: .blue.opacity(0.3), // Optional inner progress color
    progressColor: .blue,     // Main progress color
    isRounded: true,           // Round or square line caps
    isClockwise: true,         // Rotation direction
    isSpinner: false,          // Enable spinner mode
    spinnerCycleDuration: 2   // Duration of spinner rotation
)
```

## Platforms
The ProgressUI package supports the following platforms:
- iOS 14.0+
- macOS 11.0+
- macCatalyst 14.0+
- watchOS 7.0+
- tvOS 15.0+
- visionOS 1.0+

## Contribution
Feel free to contribute by creating issues or submitting pull requests. Before submitting, make sure to:
1.  Fork the repository.
2.  Create your feature branch `(git checkout -b feature/my-feature)`.
3.  Commit your changes `(git commit -m 'Add some feature')`.
4.  Push to the branch `(git push origin feature/my-feature)`.
5.  Open a pull request.

## License
This project is licensed under the **MIT License**. See the **LICENSE** file for more details.
