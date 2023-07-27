# WRITING HIGH-QUALITY CODE: A STANDALONE PROJECT DEMONSTRATING ADVANCED SOLUTIONS, PRACTICALITY AND EXPERIMENTATION - 93%! code coverage

## This project is not over-engineered or excessive in its complexity. Rather, it is intended to showcase my skills to potential employers or clients in writing high-quality code and implementing advanced solutions that can be used in larger projects. However, before using these solutions in a larger project, it is important to experiment with them on a smaller, standalone project to ensure their effectiveness and suitability.

## While it's important to showcase our skills and demonstrate our ability to implement advanced solutions, it's also crucial to find a balance between complexity and practicality in real-world projects. Ultimately, we need to adhere to the requirements and guidelines set by the organization and ensure that our code is maintainable, scalable, and efficient. Additionally, we need to consider the team dynamics and ensure that our code is easy to understand, modify, and maintain by other team members. By finding this balance, we can create high-quality code that meets the needs of the project, the organization, and the team.


## Instalation

### To run the project after downloading it, open the .xcodeproj file in Xcode, choose the FeedReader-Debug scheme, select a simulator or connected device, and click the "Run" button or press Command + R.

### Note that the test is only available on the FeedReader-Debug scheme.


## Troubleshooting Snapshot Access Errors

### If you encounter access errors when trying to access snapshot images in your iOS project, you may need to delete the snapshot folder and regenerate the snapshots. Here are the steps to do this:

1. Close Xcode and any other applications that may be accessing the snapshot folder.
2. Open Finder and navigate to the project directory.
3. Locate the __Snapshots__ folder in the FeedReader/FeedReaderTests/SnapshotViewSpec subdirectory and delete it.
4. Open Xcode and rebuild the project.
5. To re-run the tests that use snapshot images, you can choose "Test" from the "Product" menu in Xcode or press Command + U. This will rebuild the project and run all the tests, including the ones that use snapshot images.

If you still encounter access errors after deleting the snapshot folder, you may need to check the file permissions for the snapshot folder and ensure that you have read and write access to it. You can also try resetting the simulator or cleaning the build folder in Xcode.


## Project Features

1. Follows SOLID principles
2. Uses MVVM architecture
3. Achieves a code coverage of 93%
4. Includes snapshot tests and unit tests
5. Implements error handling
6. Uses dependency injection with the @Injected wrapper for easier finding
7. Follows the feedback pattern with the Loadable protocol
8. Uses the state pattern and reducers
9. Uses reactive programming
10. Follows the Quick and Nimble format for unit and snapshot tests, similar to Jasmine format
11. Names snapshot image files the same as the test descriptions
12. Separates styles
13. Includes a separate scheme (FeedReader-Mock) for mocking the project
14. Merges previews with snapshot tests to keep the same code for both
15. Implements request caching for improved performance
16. Implements image caching for faster image loading and improved user experience


## Libraries

Nimble 12.0.1
Quick 7.1.0
Swinject 2.8.3
swift-snapshot-testing 1.11.1
Nimble-snapshot-testing 3.0.0
swiftui-preview-snapshots 1.0.0 





