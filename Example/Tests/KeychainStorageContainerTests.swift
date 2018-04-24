//
//  SessionContainerTests.swift
//  SessionTools_Tests
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import XCTest
@testable import SessionTools
import KeychainAccess

class KeychainStorageContainerTests: XCTestCase {
    
    private let keychainName = "com.test.sessioncontainer"
    private var config: KeychainContainerConfig?
    private var container: KeychainStorageContainer<MockUser>?
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
    
        config = KeychainContainerConfig(keychainName: keychainName)
        container = KeychainStorageContainer<MockUser>(config: config!)
    }
    
    override func tearDown() {
        //Clear out the keychain on tear down
        let keychain = Keychain(service: keychainName)
        try? keychain.removeAll()
        
        config = nil
        container = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_KeychainContainerConfig_HasCorrectParameters() {
        XCTAssertEqual(config?.keychainName, keychainName)
    }
    
    func test_KeychainStorageContainer_HasItem() {
        let identifier = "hasItemIdentifier"
        let item = MockUser(name: "hasItem", token: "123")
        do {
            try container?.storeItem(item, forIdentifier: identifier)
            
            let hasItem = container?.hasItem(forIdentifier: identifier) ?? false
            XCTAssertTrue(hasItem)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test_KeychainStorageContainer_StoredItem() {
        let identifier = "storedItemIdentifier"
        let item = MockUser(name: "storedItem", token: "1234")
        do {
            try container?.storeItem(item, forIdentifier: identifier)
            
            let storedItem = try container?.item(forIdentifier: identifier)
            XCTAssertEqual(storedItem!, item)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func test_KeychainStorageContainer_RemovedItem() {
        let identifier = "removedItemIdentifier"
        let item = MockUser(name: "removedItem", token: "12345")
        do {
            try container?.storeItem(item, forIdentifier: identifier)
            
            try container?.removeItem(forIdentifier: identifier)
            
            let hasItem = container?.hasItem(forIdentifier: identifier)
            XCTAssertFalse(hasItem!)
            
            let storedItem = try container?.item(forIdentifier: identifier)
            XCTAssertNil(storedItem)
        } catch {
            XCTFail("\(error)")
        }
    }
}
