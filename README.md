# CityFinder

CityFinder is an iOS application designed to explore, search, and save cities from around the world. Built with SwiftUI, this app is focused on efficiency and a fluid user experience, even when handling large volumes of data.

### Key Features

- High-Performance City List: Browse through a list of over 200,000 alphabetically-sorted cities. Thanks to the use of `LazyVStack`, the UI remains smooth by rendering only the visible elements.

- Reactive Search and Filtering: A search bar that filters results in real-time. The logic is driven by `Combine`, ensuring the UI never freezes.

- Favorites Management: Save your favorite cities by tapping the star icon. Your selections are stored locally using `UserDefaults` and persist between app launches.

- Detail View: Get more information about each city, including a description and an image fetched from the Wikipedia API.

- Adaptive UI: The interface automatically adjusts for both portrait and landscape modes, taking advantage of the extra space in landscape to display an interactive map.

- Interactive Map: Visualize any city's location on a map powered by `MapKit`.

### Architecture & Technical Decisions
The project is structured following modern iOS development principles to ensure it is maintainable, testable, and efficient.

1. Clean Architecture + MVVM

The app is structured following Clean Architecture principles to ensure a clear separation of concerns, dividing the code into independent layers: `Data`, `Domain`, and `Presentation`.
Within the Presentation layer, the MVVM (Model-View-ViewModel) pattern is used:
Model: Simple data structures like `City` and `CityDetail` that represent the app's data.
View: Declarative SwiftUI screens and views that react to state changes in the ViewModel.
ViewModel: Classes that expose business logic and state to the View through `@Published` properties.
This results in a highly decoupled system where the business logic and data source can be modified without impacting the UI, making the project significantly easier to test and scale.

2. Reactive Programming with Combine

The `Combine` framework is used to handle the search filters and the city list updates. The `CitiesViewModel` combines three publishers ($cities, $searchText, and $showOnlyFavorites). Whenever one of these values changes, the pipeline triggers, performs the filtering and sorting on a background thread to avoid blocking the UI, and then delivers the result on the main thread to update the view.
Due to the list's size, performing filters on the main thread would freeze the app. The usage of the `.debounce` operator ensures that the expensive filtering operation only runs when the user pauses typing, and only if the text has actually changed.

3. Swift Concurrency (async/await)

All asynchronous operations, such as network calls, are handled with the modern async/await syntax. The views use the `.task` modifier to initiate network calls. If the user exits the screen before the data download is complete, `.task` automatically cancels the network task, which prevents updating a view that no longer exists.

4. User Experience Optimization

UI Updates: When a user saves a city as favorite, the saving operation is delegated to a background thread.

5. Keyboard Pre-warming: A "pre-warming" technique is used to load the keyboard into memory when the Home screen appears, shortening the lag on the first tap of the search bar.

6. Reusable UI Components: Custom components like `HighlightButtonStyle` are used to encapsulate user interaction logic and maintain a consistent design.

### How to Run the Project
1. Clone the repository
2. Open the `CityFinder.xcodeproj` file in Xcode
3. Select the `CitiesChallenge` scheme and a simulator of your choice
4. Run the app
