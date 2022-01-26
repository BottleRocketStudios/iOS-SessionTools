//
//  SessionTests.swift
//  Tests
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import XCTest
@testable import SessionTools

class SessionTests: XCTestCase {
    
    private let storageIdentifier = "mockSessionStorageIdentifier"
    private let config = KeychainContainerConfig(keychainName: "com.test.session")
    private var container: KeychainStorageContainer<MockUser>?
    private var mockSession: MockSession?
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        container = KeychainStorageContainer<MockUser>(config: config)
        let anyContainer = AnySessionContainer(container!)
        mockSession = MockSession(container: anyContainer, storageIdentifier: storageIdentifier, notificationPoster: NotificationCenter.default)
    }
    
    override func tearDown() {
        container = nil
        mockSession = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_InitializingASession_SetsParametersCorrectly() {
        XCTAssertNotNil(mockSession!.container)
        XCTAssertEqual(mockSession!.storageIdentifier, storageIdentifier)
        XCTAssertNotNil(mockSession?.notificationPoster)
    }
}
