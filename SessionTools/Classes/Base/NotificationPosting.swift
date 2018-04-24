//
//  NotificationPosting.swift
//  SessionTools
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import Foundation

/// Represents something that can post a notification.
public protocol NotificationPosting {
    func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]?)
}

// Extends NotificationCenter so it can be used as a default parameter in Session initialization.
extension NotificationCenter: NotificationPosting { }

// Adds userSessionStateDidChange to Notification.Name for convenience.
extension Notification.Name {
    public static let userSessionStateDidChange = Notification.Name("userSessionStateDidChange")
}

// Adds a convenience method to easily get the session state.
extension Notification {
    public var userSessionState: UserSessionStateChange? {
        return userInfo?[UserSessionConstants.userSessionStateInfoKey] as? UserSessionStateChange
    }
}
