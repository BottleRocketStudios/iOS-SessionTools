//
//  MockNotificationPoster.swift
//  SessionTools_Example
//
//  Copyright (c) 2019 Bottle Rocket Studios. All rights reserved.
//

import Foundation
import SessionTools

class MockNotificationPoster: NotificationPosting {
    
    var loginNotificationReceived = false
    var logoutNotificationReceived = false
    var updatedNotificationReceived = false
    
    func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]?) {
        let notification = Notification(name: aName, object: nil, userInfo: aUserInfo)
        guard let sessionState = notification.userSessionState else { return }
        
        switch sessionState {
        case .loggedIn:
            loginNotificationReceived = true
        case .loggedOut:
            logoutNotificationReceived = true
        case .updated:
            updatedNotificationReceived = true
        }
    }
}
