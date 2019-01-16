//
//  ViewController.swift
//  SessionTools-macOSExample
//
//  Copyright (c) 2019 Bottle Rocket Studios. All rights reserved.
//

import Cocoa

class HomeViewController: NSViewController {
    
    // MARK: - Properties
    
    @IBOutlet private var helloLabel: NSTextField!
    @IBOutlet private var refreshButton: NSButton!
    @IBOutlet private var loginButton: NSButton!
    private let guestMessage = "Hello, Guest"
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewState()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateUser), name: .userSessionStateDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .userSessionStateDidChange, object: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction private func refreshButtonTapped(_ sender: Any) {
        if let refreshViewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "RefreshViewController") as? RefreshViewController {
            presentAsSheet(refreshViewController)
        }
    }
    
    @IBAction private func loginButtonTapped(_ sender: Any) {
        if SessionManager.shared.currentUser == nil {
            // Present LoginViewController if there is not a user
            if let loginViewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "LoginViewController") as? LoginViewController {
                presentAsSheet(loginViewController)
            }
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
            helloLabel.stringValue = "Hello, \(currentUser.name)"
            refreshButton.isHidden = false
            loginButton.title = "Log Out"
        } else {
            helloLabel.stringValue = guestMessage
            refreshButton.isHidden = true
            loginButton.title = "Log In"
        }
    }
}

