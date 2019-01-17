//
//  RefreshViewController.swift
//  SessionTools-macOSExample
//
//  Copyright (c) 2019 Bottle Rocket Studios. All rights reserved.
//

import Cocoa

class RefreshViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // MARK: - IBActions
    
    @IBAction private func refreshUserButtonTapped(_ sender: Any) {
        SessionManager.shared.refreshUser()
    }
    
    @IBAction private func refreshExampleModelButtonTapped(_ sender: Any) {
        SessionManager.shared.refreshExampleModel()
    }
    
    @IBAction private func refreshAllButtonTapped(_ sender: Any) {
        SessionManager.shared.refreshAllSessions { (error) in
            if let error = error {
                debugPrint(error)
            } else {
                debugPrint("refreshed all sessions")
            }
        }
    }
}
