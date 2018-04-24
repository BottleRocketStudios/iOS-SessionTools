//
//  RefreshViewController.swift
//  SessionTools_Example
//
//  Copyright (c) 2018 Bottle Rocket Studios. All rights reserved.
//

import UIKit

class RefreshViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions
    
    @IBAction private func refreshUserButtonTapped(_ sender: UIButton) {
        SessionManager.shared.refreshUser()
    }
    
    @IBAction private func refreshExampleModelButtonTapped(_ sender: UIButton) {
        SessionManager.shared.refreshExampleModel()
    }
    
    @IBAction private func refreshAllButtonTapped(_ sender: UIButton) {
        SessionManager.shared.refreshAllSessions { (error) in
            if let error = error {
                debugPrint(error)
            } else {
                debugPrint("refreshed all sessions")
            }
        }
    }

    @IBAction private func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
