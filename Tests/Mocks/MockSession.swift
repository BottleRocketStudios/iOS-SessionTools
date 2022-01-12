//
//  MockSession.swift
//  SessionTools_Tests
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import Foundation
import SessionTools

struct MockUser: Codable, Equatable {
    let name: String
    let token: String
}

class MockSession: Session<MockUser>, Refreshable {
    
    private(set) var refreshCallCount = 0
    
    // MARK: - SessionRefreshable
    
    func refresh(completion: @escaping RefreshCompletion) {
        refreshCallCount += 1
        completion(nil)
    }
}
