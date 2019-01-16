//
//  LoginViewController.swift
//  SessionTools-macOSExample
//
//  Created by Ryan Gant on 1/15/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {
    
    // MARK: - Properties
    
    @IBOutlet private var usernameTextField: NSTextField!
    @IBOutlet private var passwordTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // MARK: - IBActions
    
    @IBAction private func logMeInButtonTapped(_ sender: Any) {
        let username = usernameTextField.stringValue
        let user = User(name: username, token: "12345")
        SessionManager.shared.userDidLogIn(user)
        dismiss(nil)
    }
    
}