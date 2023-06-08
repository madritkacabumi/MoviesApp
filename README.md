
## iOS Technical Assessment

MoviesApp implementation.

## Technical Components

* MVVM Pattern
* UI: UIKit
* Navigation: Coordinator Pattern
* Dependency Injection: Custom Dependency Injection (Assembler)
* Data binding using Combine
* Includes tests
* Third party libraries used: [Alamofire](https://github.com/Alamofire/Alamofire), [AlamofireImage](https://github.com/Alamofire/AlamofireImage)

## Documentation

- **Client App**
    - The client app has the following layers:
    - **Data** layer:
        - Responsible for providing the data from the client `NetworkService.swift` to the presentation layer (ViewModel)  through `UseCase` components.
    - **Presentation** layer:
        - Follows the MVVM pattern.
        - Utilizes the Coordinator pattern, with the `MainCoordinator` class for navigation. 
        - Uses `UINavigationController`.
        - `MoviesListViewController` is the root viewController for the navigation.
    - **Application** layer:
        - The main group contains `AppDelegate`, `SceneDelegate`, `Info.plist`, etc.
        - The `DefaultAssembler` acts as the assembler class responsible for connecting the layers above through dependency injection.

## Better architecture approach
We can substract a new layer (domain) from data layer, where the dependency would be as follows: **presentation -> domain <- datta**. This way we would have implemented a Clean Architecture, but for the purpose of 2 pages in total, it would have been a little redundant.

Thank you!
Madrit Kacabumi