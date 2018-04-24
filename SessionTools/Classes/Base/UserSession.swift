//
//  UserSession.swift
//  SessionTools
//
//  Copyright (c) 2018 Bottle Rocket Studios. All rights reserved.
//

import Foundation

/// Constants for UserSession.
public struct UserSessionConstants {
    public static let userSessionStateInfoKey = "userSessionStateInfoKey"
}

/// Represents the session state change after logging in, logging out, or updating a user.
public enum UserSessionStateChange {
    case loggedIn
    case loggedOut(Error?)
    case updated
}

/// Represents something that can track user updates like logging in, logging out, etc.
public protocol UserSessionTrackable {
    associatedtype UserType
    
    var currentUser: UserType? { get }
    var isLoggedIn: Bool { get }
    func userDidLogIn(_ user: UserType) throws
    func userDidLogOut(logoutError error: Error?) throws
    func userDidUpdate(_ user: UserType) throws
}

/// Handles storage, deletion, and retrieval of the current user. Broadcasts notifications when user session state changes. Can call a RefreshHandler block if provided.
public class UserSession<T: Codable>: Session<T>, UserSessionTrackable, Refreshable {
  
    // MARK: - Init
    
    public init(container: AnySessionContainer<T>, storageIdentifier: String, notificationPoster: NotificationPosting?, refreshHandler: RefreshHandler? = nil, itemEncoder: JSONEncoder = JSONEncoder(), itemDecoder: JSONDecoder = JSONDecoder()) {
        self.refreshHandler = refreshHandler
        super.init(container: container, storageIdentifier: storageIdentifier, notificationPoster: notificationPoster, itemEncoder: itemEncoder, itemDecoder: itemDecoder)
    }
    
    // MARK: - UserSessionTrackable
    
    public var currentUser: T? {
        return currentItem
    }
    
    public var isLoggedIn: Bool {
        return hasItem
    }
    
    public func userDidLogIn(_ user: T) throws {
        try updateItem(user)
        postNotification(state: .loggedIn)
    }
    
    public func userDidLogOut(logoutError error: Error?) throws {
        try deleteItem()
        postNotification(state: .loggedOut(error))
    }
    
    public func userDidUpdate(_ user: T) throws {
        try updateItem(user)
        postNotification(state: .updated)
    }
    
    // MARK: - SessionRefreshable

    public var refreshHandler: ((@escaping RefreshCompletion) -> Void)?

    public func refresh(completion: @escaping RefreshCompletion) {
        refreshHandler?(completion)
    }
    
    // MARK: - Private
    
    private func postNotification(state: UserSessionStateChange) {
        notificationPoster?.post(name: .userSessionStateDidChange, object: nil, userInfo: [UserSessionConstants.userSessionStateInfoKey: state])
    }
}
