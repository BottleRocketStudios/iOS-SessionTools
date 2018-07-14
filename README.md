# SessionTools

[![CI Status](http://img.shields.io/travis/BottleRocketStudios/iOS-SessionTools.svg?style=flat)](https://travis-ci.org/BottleRocketStudios/iOS-SessionTools)
[![Version](https://img.shields.io/cocoapods/v/SessionTools.svg?style=flat)](http://cocoapods.org/pods/SessionTools)
[![License](https://img.shields.io/cocoapods/l/SessionTools.svg?style=flat)](http://cocoapods.org/pods/SessionTools)
[![Platform](https://img.shields.io/cocoapods/p/SessionTools.svg?style=flat)](http://cocoapods.org/pods/SessionTools)

## Purpose
This library makes session management easier. There are a few main goals:

* Provide a simple way to create "session" objects for storing, updating, deleting, and refreshing session-related data (credentials, tokens, etc.).
* Provide a pre-built UserSession to simplify the work needed to deal with user login/logout.
* Broadcast login/logout/update notifications when your model object changes.
* Store your model object in a secure storage mechanism since it usually contains sensitve information.

## Key Concepts
* **Session** - A base class for creating something that can store, retrieve, and delete an item in a `SessionContainer`. Can post notifications by providing something conforming to `NotificationPosting` (`NSNotificationCenter` conforms to this by default).
* **SessionContainer** - A conatiner for storing data to the keychain.
* **Refreshable** - Represents something that can be refreshable. In our use case, a `Session<T>`.
* **NotficationPosting** - Represents something that can post a notification.
* **UserSession** - Handles storage, deletion, and retrieval of the current user. Broadcasts notifications when user session state changes. Can call a `RefreshHandler` block if provided.
* **KeychainStorageContainer** - A container that uses the keychain as the backing store. You can make your own container by subclassing `SessionContainer`.
* **KeychainContainerConfig** - A class to configure the `KeychainStorageContainer` for use.

## Usage

### SessionTools out of the box uses the keychain to store your session data. To allow for maximum flexibility, you can use the `SessionTools/Base` subspec to integrate SessionTools without the keychain dependencies. Going forward, we are assuming you are using this on iOS and want to use the keychain.

#### Preparation

##### 1. Create a model object that conforms to `Codable`.
You've probably already created some variation of this in your codebase.
``` swift
struct Model: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let token: String
}
```

##### 2. Create a `KeychainContainerConfig` supplied with a `keychainName`.
``` swift
let config = KeychainContainerConfig(keychainName: "your.keychain.name")
```

##### 3. Create a `KeychainStorageContainer `supplied with your `KeychainContainerConfig`. 
You can also create your own object conforming to `SessionContainer` and instantiate it if you're not wanting to use the default keychain storage mechanism.
``` swift
let container = KeychainStorageContainer<Model>(config: config)
```

##### 4. Wrap your storage container in the `AnySessionContainer` type erased container.
``` swift
let anyContainer = AnySessionContainer(container)
```

#### Now you can make use of a `Session` in a few different ways.

##### Option 1 - Use the `Session<T>` class as-is.
You just need to supply your model object's type, the container to store it in, and the key that will be associated with your object in the storage container.
``` swift
let session = Session<Model>(container: anyContainer, storageIdentifier: "identifier.or.key.for.your.model.object")
```

##### Option 2 - Create a subclass of `Session<T>`, supplying your model for the generic placeholder type.
Optionally, conform to `Refreshable` if you want to automatically handle refreshing your model when it's expired (e.g. an API token).
``` swift
class ModelSession: Session<Model>, Refreshable {
    // your class code here

    // MARK: - Refreshable

    func refresh(completion: @escaping RefreshCompletion) {
        // your refresh code here
        completion(nil)
    }
}
```

##### Option 3 (*Most Common*) - Use `UserSession<T>`, a `Session<T>` subclass already setup for you to deal with **common log in/out operations**.
``` swift
let userSession = UserSession<Model>(container: anyContainer, storageIdentifier: "identifier.for.your.model.object", notificationPoster: NotificationCenter.default)
```
You can also supply a `refreshHandler` to the UserSession initializer if you want to automatically handle refreshing your model when it's expired (e.g. an API token).
``` swift
private static func userRefreshHandler(_ completion: @escaping RefreshCompletion) -> Void {
    // your refresh code
    completion(nil)
}

let userSession = UserSession<Model>(container: container, storageIdentifier: "identifier.for.your.model.object", notificationPoster: NotificationCenter.default, refreshHandler: userRefreshHandler)
```

Now you can easily get a reference to your app's current user.
``` swift
let currentUser = userSession.currentUser
```
You can also check if there is currently a user logged in.
```swift
let isUserLoggedIn = userSession.isLoggedIn
```

`UserSession<T>` also contains methods that can be called to log in, log out, or update the information.
``` swift
do {
    try userSession.didLogIn(model)
    try userSession.didLogOut(nil)
    try userSession.didUpdate(model)
} catch {
    // Handle container read/write errors here
}
```

Parts of your code can optionally observe these log in/out/update events by subscribing to the `Notification.Name.userSessionStateDidChange` notification.
``` swift
NotificationCenter.default.addObserver(self, selector: #selector(didUpdateUser:), name: .sessionStateDidChange, object: nil)
```

Access the `userSessionState` property on the notification to easily get the state change that occurred.
``` swift
@objc private func didUpdateUser(_ notification: Notification) {
    guard let sessionState = notification.userSessionState else { return }
    
    // Do something with the state
    switch sessionState {
    case .loggedIn:
        // ...
    case .loggedOut:
        // ...
    case .updated:
        // ...
    }
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
* iOS 9.0+
* Swift 4.1

## Installation

SessionTools is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SessionTools'
```

Or if you're not working in an environment with access to the keychain, use the base subspec:

```ruby
pod 'SessionTools/Base'
```

## Contributing

See the [CONTRIBUTING] document. Thank you, [contributors]!

[CONTRIBUTING]: CONTRIBUTING.md
[contributors]: https://github.com/BottleRocketStudios/iOS-SessionManager/graphs/contributors
