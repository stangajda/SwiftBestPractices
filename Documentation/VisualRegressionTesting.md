# Visual Regression Testing

## Visual regression testing can also be applied to iOS development with Swift. It's particularly valuable for ensuring the visual consistency of your app across different devices, screen sizes, and iOS versions.

## Good uses:

- **User Interface Consistency:** To check that your UI looks as expected on all supported devices and orientations, especially after changes in the layout or style.
- **Component Libraries:** If you're maintaining a library of reusable UI components, visual regression testing can help ensure that changes to one component don't negatively impact others.
- **Theming and Branding:** When your app supports multiple themes or branding, and you want to ensure that visual elements like colors and fonts remain consistent across changes.
- **Accessibility Testing:** To verify that accessibility enhancements or changes do not disrupt the visual layout or readability.

## Less ideal uses:

- **During Rapid Prototyping:** When the UI is expected to change frequently as the design evolves, visual regression testing may slow down the development process due to frequent snapshot updates.
- **For Testing Non-Visual Logic:** Visual regression testing is not suitable for testing the app's business logic, data handling, or networking code. Use unit and integration tests for these aspects.
- **Highly Dynamic Interfaces:** For interfaces that contain elements with frequent content changes (e.g., news feeds), visual regression testing may result in many false positives.


## Implementing Visual Regression Testing/Snapshot Testing with Quick/Nimble and SwiftUI

Snapshot testing is a powerful technique to ensure visual consistency in your SwiftUI views. Quick and Nimble make it easy to integrate snapshot testing into your project. Here's a step-by-step guide on how to implement and use snapshot tests with Quick and Nimble in a SwiftUI project:

### Use SnapshotManager for Previews

Inside your SwiftUI view's Preview struct, create a `SnapshotManager` to handle different view states:

```swift
// NewView_Previews.swift

struct NewView_Previews: PreviewProvider {
  
  static var previews: some View {
    snapshots.previews.previewLayout(.sizeThatFits)
  }

  static var snapshots: PreviewSnapshots<AnyMoviesListViewModelProtocol> {
        Injection.main.mockViewModel() // add mock dependecy injection implementation
        @Injected(name: .movieListStateLoaded) var viewModelLoaded: AnyMoviesListViewModelProtocol //add injection for each state
        ...
        
        return PreviewSnapshots(
            configurations: [
                .init(named: .movieListStateLoaded, state: viewModelLoaded),
                ...
            ],
            configure: { state in
                MoviesListView(viewModel: state)
            }
        )
    }
}
```


### Snapshot Tests for NewView

In this document, we'll go through the process of writing Snapshot Tests for the `NewView` in your Swift project.


```swift
// NewViewTests.swift

import Foundation
@testable import MyAppModule
import SwiftUI
import Nimble
import Quick
import SnapshotTesting
import Nimble_SnapshotTesting
import PreviewSnapshotsTesting

class NewViewSpec: QuickSpec {
  override func spec() { 
    describe("NewView") {
      
      // Tests for different view states
      it("should match default state") {
        let viewController = NewView_Previews.snapshots.getViewController()
        expect(viewController).toEventually(haveValidSnapshot(as: .image))
      }
      
      // Add more tests for different view states as needed
      
    }
  }
}
```


