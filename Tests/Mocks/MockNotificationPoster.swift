//
//  MockNotificationPoster.swift
//  SessionTools_Example
//
//  Created by Ryan Gant on 4/9/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SessionTools

class MockNotificationPoster: NotificationPosting {
    
    var loginNotificationReceived = false
    var logoutNotificationReceived = false
    var updatedNotificationReceived = false
    
    func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]?) {
        guard let sessionState = aUserInfo?[UserSessionConstants.userSessionStateInfoKey] as? UserSessionStateChange else { return }

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
