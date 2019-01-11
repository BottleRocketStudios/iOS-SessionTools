//
//  SessionManager.swift
//  SessionTools_Example
//
//  Copyright (c) 2018 Bottle Rocket Studios. All rights reserved.
//

import Foundation
import SessionTools
import KeychainAccess

/// A model representing user info.
struct User: Codable {
    let name: String
    let token: String
}

/// Manages your sessions.
class SessionManager {
    
    // MARK: - Singleton
    
    static let shared = SessionManager()
    
    // MARK: - Properties
    
    private var userSession: UserSession<User>
    private var exampleSession: ExampleSession
    
    var currentUser: User? {
        return userSession.currentUser
    }
    
    // MARK: - Private
    
    private init() {
        // Setup container config for all keychain containers
        let containerConfig = KeychainContainerConfig(keychainName: "com.app.name")

        // Setup userSession
        let userContainer = KeychainStorageContainer<User>(config: containerConfig)
        let anyUserContainer = AnySessionContainer(userContainer)
        userSession = UserSession(container: anyUserContainer, storageIdentifier: "userStorageIdentifier", notificationPoster: NotificationCenter.default, refreshHandler: SessionManager.userRefreshHandler)
        
        // Setup exampleSession
        let exampleModelContainer = KeychainStorageContainer<ExampleModel>(config: containerConfig)
        let anyExampleModelContainer = AnySessionContainer(exampleModelContainer)
        exampleSession = ExampleSession(container: anyExampleModelContainer, storageIdentifier: "exampleModelStorageIdentifier")
    }
    
    /// A refresh handler for the userSession
    private static func userRefreshHandler(_ completion: @escaping RefreshCompletion) {
        completion(nil)
    }
    
    // MARK: - Public
    
    func userDidLogIn(_ user: User) {
        //Saves user object to container
        try? userSession.userDidLogIn(user)
        
        //Add an example session model when we log in as well to save it to the container
        let exampleModel = ExampleModel(identifier: "Example", numberOfTimesRefreshed: 0)
        try? exampleSession.updateItem(exampleModel)
    }
    
    func userDidLogOut() {
        //Removes user object from container
        try? userSession.userDidLogOut(logoutError: nil)
        
        //Remove example model on logout
        try? exampleSession.deleteItem()
    }
    
    func refreshUser() {
        userSession.refresh { (_) in
            debugPrint("refreshed UserSession: \(String(describing: self.userSession.currentUser))")
        }
    }
    
    func refreshExampleModel() {
        exampleSession.refresh { (_) in
            debugPrint("refreshed ExampleSession -- number of times: \(self.exampleSession.currentItem?.numberOfTimesRefreshed ?? 0)")
        }
    }
    
    /// Example of how to refresh all sessions with one call.
    func refreshAllSessions(completion: @escaping RefreshAllCompletion) {
        let sessions: [Refreshable] = [userSession, exampleSession]
        sessions.refresh { (refreshErrors) in
            debugPrint("All sessions refreshed with errors: \(refreshErrors ?? [])")
        }
    }
}
