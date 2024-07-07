This contains the demo Xcode project for the Swift SwiftUI and Environment Session for "Apple Developers Club iOS | Swift | macOS | watchOS".

This project contains 
- the Array Builder example for Result Builder.
- A small function to learn and test about the Task locals
- How to use custom Environment to build a FetchingView (similar to ContentUnavailableView) with easy error handling.

```swift
FetchingView(state: .error("Something went wrong")) {
  List(1...10, id: \.self) {
    Text("\($0)")
  }
}
.retry {
  HStack {
    Button("Retry") {
      print("Retry button tapped")
    }
    .buttonStyle(.bordered)
    Button("Login") {
      print("Login Again")
    }
    .buttonStyle(.borderedProminent)
  }
}
```
