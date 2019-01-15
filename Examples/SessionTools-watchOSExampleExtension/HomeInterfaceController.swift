//
//  HomeInterfaceController.swift
//  SessionTools-watchOSExample Extension
//
//  Copyright © 2019 Bottle Rocket Studios. All rights reserved.
//

import WatchKit
import Foundation

class HomeInterfaceController: WKInterfaceController {
    
    // MARK: - Properties
    
    @IBOutlet private var helloLabel: WKInterfaceLabel!
    @IBOutlet private var refreshButton: WKInterfaceButton!
    @IBOutlet private var loginButton: WKInterfaceButton!
    private let guestMessage = "Hello, Guest"

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        updateViewState()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateUser), name: .userSessionStateDidChange, object: nil)
    }

    // MARK: - IBActions
    
    @IBAction private func refreshButtonTapped() {
        presentController(withName: "RefreshInterfaceController", context: nil)
    }
    
    @IBAction private func loginButtonTapped() {
        if SessionManager.shared.currentUser == nil {
            // Present Login interface if there is not a user
            presentController(withName: "LoginInterfaceController", context: nil)
        } else {
            // Log out
            SessionManager.shared.userDidLogOut()
        }
    }
    
    // MARK: - Notifications
    
    @objc private func didUpdateUser(_ notification: Notification) {
        guard let sessionState = notification.userSessionState else { return }
        
        // Update label and buttons when a user is logged in, logged out, or updated.
        switch sessionState {
        case .loggedIn:
            debugPrint("User logged in")
        case .loggedOut:
            debugPrint("User logged out")
        case .updated:
            debugPrint("User updated")
        }
        
        updateViewState()
    }
    
    // MARK: - Helper
    
    private func updateViewState(forUser user: User? = SessionManager.shared.currentUser) {
        if let currentUser = user {
            helloLabel.setText("Hello, \(currentUser.name)")
            refreshButton.setHidden(false)
            loginButton.setTitle("Log Out")
        } else {
            helloLabel.setText(guestMessage)
            refreshButton.setHidden(true)
            loginButton.setTitle("Log In")
        }
    }
}
