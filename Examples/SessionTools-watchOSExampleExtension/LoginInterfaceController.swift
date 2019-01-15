//
//  LoginInterfaceController.swift
//  SessionTools-watchOSExample Extension
//
//  Created by Ryan Gant on 1/15/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import WatchKit
import Foundation

class LoginInterfaceController: WKInterfaceController {
    
    // MARK: - Actions

    @IBAction private func logMeInButtonTapped() {
        //This is hardcoded here to save the trouble of implementing input UI
        let user = User(name: "test", token: "12345")
        SessionManager.shared.userDidLogIn(user)
        dismiss()
    }
}
