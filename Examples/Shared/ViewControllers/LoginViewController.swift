//
//  LoginViewController.swift
//  SessionTools_Example
//
//  Copyright (c) 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    
    @IBAction private func logMeInButtonTapped(_ sender: UIButton) {
        if let username = usernameTextField.text {
            let user = User(name: username, token: "12345")
            SessionManager.shared.userDidLogIn(user)
            
            dismiss(animated: true, completion: nil)
        }
    }
}
