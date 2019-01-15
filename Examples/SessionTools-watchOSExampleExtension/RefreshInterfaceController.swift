//
//  RefreshInterfaceController.swift
//  SessionTools-watchOSExample Extension
//
//  Created by Ryan Gant on 1/15/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import WatchKit
import Foundation

class RefreshInterfaceController: WKInterfaceController {
    
    // MARK: - IBActions
    
    @IBAction private func refreshUserButtonTapped() {
        SessionManager.shared.refreshUser()
    }
    
    @IBAction private func refreshExampleModelButtonTapped() {
        SessionManager.shared.refreshExampleModel()
    }
    
    @IBAction private func refreshAllButtonTapped() {
        SessionManager.shared.refreshAllSessions { (error) in
            if let error = error {
                debugPrint(error)
            } else {
                debugPrint("refreshed all sessions")
            }
        }
    }
    
    @IBAction private func closeButtonTapped() {
        dismiss()
    }
}
