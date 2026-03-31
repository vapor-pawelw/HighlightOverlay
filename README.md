# HighlightOverlay

A lightweight SwiftUI view modifier that dims the screen and cuts out a highlighted area around a selected view — useful for onboarding flows, feature tours, and tooltip spotlights.

https://user-images.githubusercontent.com/47155744/230316325-8bf35bde-2a7b-42b3-b26f-bf113fb61661.mov

## Features

- Declarative API — two modifiers, zero boilerplate
- Animated transitions between highlighted views
- Customizable mask shape, padding, and blur
- Coordinate-space-aware positioning via `PreferenceKey`
- No hit-testing interference — users can still interact with content beneath

## Usage

```swift
struct OnboardingView: View {
    @State private var spotlight: String? = "profile"

    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .tooltipItem("profile")
                .onTapGesture { spotlight = "settings" }

            Image(systemName: "gearshape")
                .tooltipItem("settings")
                .onTapGesture { spotlight = nil } // dismiss
        }
        .withHighlightOverlay(
            highlighting: $spotlight,
            maskView: Circle().foregroundColor(.black)
        )
    }
}
```

1. Tag views with `.tooltipItem("id")`
2. Wrap the container with `.withHighlightOverlay(highlighting:maskView:)`
3. Set the binding to a tag to spotlight it, or `nil` to dismiss

## API

### `.tooltipItem(_ id: String)`

Registers a view as a highlight target.

### `.withHighlightOverlay(...)`

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `highlighting` | `Binding<String?>` | — | ID of the currently highlighted view, `nil` to hide |
| `maskView` | `some View` | — | Shape used for the cutout (e.g. `Circle()`, `RoundedRectangle(...)`) |
| `maskPadding` | `CGFloat` | `24` | Extra space around the highlighted view |
| `maskBlur` | `CGFloat` | `4` | Blur radius on the mask edge |

## Installation

Copy `HighlightOverlay.swift` into your project — it's a single file with no dependencies.

## Requirements

- iOS 15+ / macOS 12+
- Swift 5.7+

## License

MIT
