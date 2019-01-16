//
//  LoginInterfaceController.swift
//  SessionTools-watchOSExample Extension
//
//  Copyright (c) 2019 Bottle Rocket Studios. All rights reserved.
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
