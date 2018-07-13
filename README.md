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

### SessionTools out of the box uses the keychain to store your session data. To allow for maximum flexibility, you can use the SessionTools/Base subspec to integrate SessionTools without the keychain dependencies. Going forward, we are assuming you are using this on iOS and want to use the keychain. You'll need to create a few things before working with a Session.

#### 1. Create a model object that conforms to Codable.
``` swift
struct Model: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let token: String
}
```

#### 2. Create a KeychainContainerConfig supplied with a keychainName.
``` swift
let config = KeychainContainerConfig(keychainName: "your.keychain.name")
```

#### 3. Create a KeychainStorageContainer supplied with a KeychainContainerConfig. (Or create your own SessionContainer subclass and instantiate it)
``` swift
let container = KeychainStorageContainer<Model>(config: config)
```

#### 4. Wrap your storage container in a type erased container.
``` swift
let anyContainer = AnySessionContainer(container)
```

### Now you can make use of a Session in a few different ways.

#### Option 1 - Use Session as is by suppling your placeholder type.
``` swift
let session = Session<Model>(container: anyContainer, storageIdentifier: "identifier.for.your.model.object")
```

#### Option 2 - Create a subclass of Session with your model as the placeholder type. Optionally, conform to Refreshable to refresh your session.
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

#### Option 3 - Use UserSession, a Session already setup for you to deal with logging in/out and broadcasting notifications.
``` swift
let userSession = UserSession<Model>(container: anyContainer, storageIdentifier: "identifier.for.your.model.object", notificationPoster: NotificationCenter.default)
```
You can also supply a refreshHandler to UserSession to use whenever refreshing.
``` swift
private static func userRefreshHandler(_ completion: @escaping RefreshCompletion) -> Void {
    // your refresh code
    completion(nil)
}

let userSession = UserSession<Model>(container: container, storageIdentifier: "identifier.for.your.model.object", notificationPoster: NotificationCenter.default, refreshHandler: userRefreshHandler)
```

Get current user info.
``` swift
userSession.currentUser
userSession.isLoggedIn
```

Handle logging in, logging out, and updating.
``` swift
do {
    try userSession.didLogIn(model)
    try userSession.didLogOut(nil)
    try userSession.didUpdate(model)
} catch {
    //Handle container errors here
}
```

Observe notifications.
``` swift
NotificationCenter.default.addObserver(self, selector: #selector(didUpdateUser:), name: .sessionStateDidChange, object: nil)
```

Easily get the state change from the notification payload.
``` swift
@objc private func didUpdateUser(_ notification: Notification) {
    guard let sessionState = notification.userSessionState else { return }
    //Do something with the state
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
