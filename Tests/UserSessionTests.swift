//
//  UserSessionTests.swift
//  SessionTools_Tests
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import XCTest
@testable import SessionTools

enum UserSessionError: Error {
    case general
}

class UserSessionTests: XCTestCase {
    
    private let storageIdentifier = "userSessionStorageIdentifier"
    private let user = MockUser(name: "testName", token: "12345")
    private var container: MockStorageContainer<MockUser>?
    private var userSession: UserSession<MockUser>?
    private var refreshCallCount = 0
    private var notificationPoster: MockNotificationPoster?
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        container = MockStorageContainer<MockUser>()
        let anyContainer = AnySessionContainer(container!)
        notificationPoster = MockNotificationPoster()
        userSession = UserSession<MockUser>(container: anyContainer, storageIdentifier: storageIdentifier, notificationPoster: notificationPoster!)
    }
    
    override func tearDown() {
        logoutUser()
        container = nil
        notificationPoster = nil
        userSession = nil
        refreshCallCount = 0
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_UserSession_HasCorrectParameters() {
        XCTAssertNotNil(userSession!.container)
        XCTAssertEqual(userSession!.storageIdentifier, storageIdentifier)
        XCTAssertNotNil(userSession?.notificationPoster)
    }
    
    func test_UserSession_UserLoggedIn() {
        do {
            try userSession!.userDidLogIn(user)
            XCTAssertTrue(notificationPoster?.loginNotificationReceived ?? false)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test_UserSession_UserLoggedOut() {
        do {
            try userSession!.userDidLogIn(user)
            logoutUser()
            XCTAssertTrue(notificationPoster?.logoutNotificationReceived ?? false)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test_UserSession_UserUpdated() {
        do {
            try userSession!.userDidUpdate(user)
            XCTAssertTrue(notificationPoster?.updatedNotificationReceived ?? false)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test_RefreshUserSession_CallsRefreshHandler() {
        userSession?.refreshHandler = refreshHandler(_:)
        userSession?.refresh(completion: { (_) in
            XCTAssertEqual(self.refreshCallCount, 1)
        })
    }
    
    func test_RefreshUserSession_RefreshMultipleSessions() {
        userSession?.refreshHandler = refreshHandler(_:)
        let allSessions: [Refreshable] = [userSession!, userSession!]
        
        let expectation = XCTestExpectation(description: "All sessions refresh")
        allSessions.refresh { (_) in
            //Since we're really just refreshing the same session twice, this should be 2
            XCTAssertEqual(self.refreshCallCount, 2)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_RefreshUserSession_RefreshMultipleSessionWithFailure() {
        userSession?.refreshHandler = refreshHandler(_:)
        
        //Setup another session to throw a failure when refreshing
        let anyContainer = AnySessionContainer(container!)
        let failUserSession = UserSession<MockUser>(container: anyContainer, storageIdentifier: storageIdentifier, notificationPoster: notificationPoster!)
        failUserSession.refreshHandler = failureRefreshHandler(_:)
        
        let allSessions: [Refreshable] = [userSession!, failUserSession]
        
        let expectation = XCTestExpectation(description: "All sessions refresh")
        allSessions.refresh { (error) in
            //Make sure the error is passed through
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    // MARK: - Private
    
    private func logoutUser() {
        if userSession!.isLoggedIn {
            do {
                try userSession!.userDidLogOut(logoutError: nil)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    private func refreshHandler(_ completion: @escaping RefreshCompletion) {
        refreshCallCount += 1
        completion(nil)
    }
    
    private func failureRefreshHandler(_ completion: @escaping RefreshCompletion) {
        completion(RefreshError.unableToRefresh(error: UserSessionError.general))
    }
}
