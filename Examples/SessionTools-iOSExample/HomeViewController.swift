//
//  HomeViewController.swift
//  SessionTools_Example
//
//  Copyright (c) 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit
import SessionTools

class HomeViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private var helloLabel: UILabel!
    @IBOutlet private var refreshButton: UIButton!
    @IBOutlet private var loginButton: UIButton!
    private let guestMessage = "Hello, Guest"
    
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
    
    @IBAction private func refreshButtonTapped(_ sender: UIButton) {
        let refreshViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RefreshViewController")
        present(refreshViewController, animated: true, completion: nil)
    }

    @IBAction private func loginButtonTapped(_ sender: UIButton) {
        if SessionManager.shared.currentUser == nil {
            // Present LoginViewController if there is not a user
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            present(loginViewController, animated: true, completion: nil)
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
        case .loggedOut(_):
            debugPrint("User logged out")
        case .updated:
            debugPrint("User updated")
        }
        
        updateViewState()
    }
    
    // MARK: - Helper
    
    private func updateViewState(forUser user: User? = SessionManager.shared.currentUser) {
        if let currentUser = user {
            helloLabel.text = "Hello, \(currentUser.name)"
            refreshButton.isHidden = false
            loginButton.setTitle("Log Out", for: .normal)
        } else {
            helloLabel.text = guestMessage
            refreshButton.isHidden = true
            loginButton.setTitle("Log In", for: .normal)
        }
    }
}
