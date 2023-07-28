# WRITING HIGH-QUALITY CODE: A STANDALONE PROJECT DEMONSTRATING ADVANCED SOLUTIONS, PRACTICALITY AND EXPERIMENTATION - 93%! code coverage

## This project is not over-engineered or excessive in its complexity. Rather, it is intended to showcase my skills to potential employers or clients in writing high-quality code and implementing advanced solutions that can be used in larger projects. However, before using these solutions in a larger project, it is important to experiment with them on a smaller, standalone project to ensure their effectiveness and suitability.

## While it's important to showcase our skills and demonstrate our ability to implement advanced solutions, it's also crucial to find a balance between complexity and practicality in real-world projects. Ultimately, we need to adhere to the requirements and guidelines set by the organization and ensure that our code is maintainable, scalable, and efficient. Additionally, we need to consider the team dynamics and ensure that our code is easy to understand, modify, and maintain by other team members. By finding this balance, we can create high-quality code that meets the needs of the project, the organization, and the team.


## Instalation

### To run the project after downloading it, open the .xcodeproj file in Xcode, choose the FeedReader-Debug scheme, select a simulator or connected device, and click the "Run" button or press Command + R.

### This standalone project has been confirmed to be working on Xcode 14.3 and simulators for the following devices: iPhone 14 Pro and iPhone 14 Pro Max, running iOS 16.0. The project has also been tested on a real device, iPhone 11 Pro Max, running iOS 16.1.1.

### Please note that both unit tests and snapshot tests are only available when using the FeedReader-Debug scheme. The snapshot test working for the iPhone 14 Pro simulator.


## Troubleshooting Snapshot Access Errors

### If you encounter access errors when trying to access snapshot images in your iOS project, you may need to delete the snapshot folder and regenerate the snapshots. Here are the steps to do this:

1. Close Xcode and any other applications that may be accessing the snapshot folder.
2. Open Finder and navigate to the project directory.
3. Locate the __Snapshots__ folder in the FeedReader/FeedReaderTests/SnapshotViewSpec subdirectory and delete it.
4. Open Xcode and rebuild the project.
5. To re-run the tests that use snapshot images, you can choose "Test" from the "Product" menu in Xcode or press Command + U. This will rebuild the project and run all the tests, including the ones that use snapshot images.

If you still encounter access errors after deleting the snapshot folder, you may need to check the file permissions for the snapshot folder and ensure that you have read and write access to it. You can also try resetting the simulator or cleaning the build folder in Xcode.


## Technical Features

1. Follows SOLID principles
2. Uses MVVM architecture
3. Achieves a code coverage of 93%
4. Includes snapshot tests and unit tests
5. Implements error handling
6. Uses dependency injection with the @Injected wrapper for easier finding
7. Registers dependencies in a separate file for better organization and maintainability
8. Follows the feedback pattern with the Loadable protocol
9. Uses the state pattern and reducers
10. Uses reactive programming
11. Follows the Quick and Nimble format for unit and snapshot tests, similar to Jasmine format
12. Names snapshot image files the same as the test descriptions
13. Separates styles for better maintainability and reusability
14. Includes a separate scheme (FeedReader-Mock) for mocking the project
15. Merges previews with snapshot tests to keep the same code for both
16. Implements request caching for improved performance
17. Implements image caching for faster image loading and improved user experience
18. Uses generics for type safety and code reuse


## 3rd party Libraries

Nimble 12.0.1
Quick 7.1.0
Swinject 2.8.3
swift-snapshot-testing 1.11.1
Nimble-snapshot-testing 3.0.0
swiftui-preview-snapshots 1.0.0 

## Sources
https://www.vadimbulavin.com/modern-mvvm-ios-app-architecture-with-combine-and-swiftui/
https://github.com/hmlongco/Resolver
https://github.com/Swinject/Swinject
https://github.com/Quick/Quick
https://github.com/Quick/Nimble
https://www.browserstack.com/guide/snapshot-testing-ios
https://github.com/pointfreeco/swift-snapshot-testing
https://github.com/ashfurrow/Nimble-Snapshots
https://swiftpackageindex.com/doordash-oss/swiftui-preview-snapshots
https://blog.devgenius.io/unit-test-networking-code-in-swift-without-making-loads-of-mock-classes-74489d0b12a8

## MIT License

Copyright (c) 2023 Stan Gajda

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
