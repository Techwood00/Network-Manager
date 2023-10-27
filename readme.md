# NetworkManager

NetworkManager is a flexible and robust Swift class for making API requests. It follows SOLID principles and incorporates Protocol-Oriented Programming (POP) for clean and extensible network operations.

## Features

- **Modular Design**: The `NetworkManager` class is designed to have a single responsibility: making API requests, adhering to the Single Responsibility Principle (SRP).
- **HTTP Method Enums**: Utilizes Swift enums to represent HTTP methods, making code more readable and less error-prone.
- **Retry Mechanism**: Automatic request retry with a configurable retry count to enhance network resilience.
- **Protocol-Oriented**: Separation of concerns using protocols for extensibility and testability.
- **Type-Safe**: Strongly typed response handling with the Swift `Result` type.
- **Easy Integration**: Simple and intuitive API for making network requests.

## Getting Started

### Installation

1. Copy the `Sources` folder into your project.
2. Ensure the file is included in your project's target.

### Usage

1. Import the `NetworkManager` module into your Swift file:

    ```swift
    import Foundation
    ```

2. Define your API request by conforming to the `NetworkRequest` protocol and create an instance of it. For example:

    ```swift
    let request = APIRequest(endpoint: yourAPIURL, method: .get, parameters: nil, headers: nil)
    ```

3. Make the API request using the `NetworkManager`:

    ```swift
    NetworkManager.shared.request(request, responseType: APIResponse<YourResponseType>.self) { result in
        switch result {
        case .success(let response):
            // Handle the successful response
            print(response)
        case .failure(let error):
            // Handle the error
            print(error)
        }
    }
    ```

   Replace `yourAPIURL` with the actual API endpoint, and `YourResponseType` with the Codable type that represents the expected API response.

### Configuration

You can configure the maximum retry count by changing the `maxRetryCount` property in the `NetworkManager` class. By default, it's set to 3.

## Contributing

Contributions are welcome! If you'd like to contribute to this project, please open an issue or submit a pull request.

## Acknowledgments

- Inspired by SOLID principles and Protocol-Oriented Programming.
- Built with ❤️ and code.  
