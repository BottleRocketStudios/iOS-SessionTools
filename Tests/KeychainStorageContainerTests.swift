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
    private let keychainAccessGroup = "com.test.group"
    private var config: KeychainContainerConfig?
    private var container: KeychainStorageContainer<MockUser>?
    
    private let installIdentifier = "testIdentifier"
    private let alternateInstallIdentifier = "alternateTestIdentifier"
    private let currentInstallKeychainName = "com.test.sessioncontainer.currentinstall"
    private var currentInstallLifecycle: KeychainLifecycle?
    private var currentInstallConfig: KeychainContainerConfig?
    private var currentInstallContainer: KeychainStorageContainer<MockUser>?
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
    
        config = KeychainContainerConfig(keychainName: keychainName, accessGroupName: keychainAccessGroup)
        container = KeychainStorageContainer<MockUser>(config: config!)
        currentInstallLifecycle = KeychainLifecycle.currentInstall(identifier: installIdentifier)
        currentInstallConfig = KeychainContainerConfig(keychainName: currentInstallKeychainName, accessGroupName: keychainAccessGroup, lifecycle: currentInstallLifecycle!)
        currentInstallContainer = KeychainStorageContainer(config: currentInstallConfig!)
    }
    
    override func tearDown() {
        //Clear out the keychain on tear down
        let keychain = Keychain(service: keychainName)
        try? keychain.removeAll()
        let currentInstallKeychain = Keychain(service: installIdentifier + keychainName)
        try? currentInstallKeychain.removeAll()
        let alternateInstallKeychain = Keychain(service: alternateInstallIdentifier + keychainName)
        try? alternateInstallKeychain.removeAll()
        
        config = nil
        container = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_UnmanagedKeychainContainerConfig_HasCorrectParameters() {
        XCTAssertEqual(config?.keychainName, keychainName)
        XCTAssertEqual(config?.accessGroupName, keychainAccessGroup)
        XCTAssertEqual(config?.keychainLifecycle, KeychainLifecycle.unmanaged)
    }
    
    func test_CurrentInstallKeychainContainerConfig_HasCorrectParameters() {
        XCTAssertEqual(currentInstallConfig?.keychainName, installIdentifier + currentInstallKeychainName)
        XCTAssertEqual(config?.accessGroupName, keychainAccessGroup)
        XCTAssertEqual(currentInstallConfig?.keychainLifecycle, currentInstallLifecycle)
    }
    
    func test_KeychainStorageContainer_Equivalence() {
        let equivalentConfig = KeychainContainerConfig(keychainName: keychainName, accessGroupName: keychainAccessGroup)
        let equivalentContainer = KeychainStorageContainer<MockUser>(config: equivalentConfig)
        
        let nonEquivalentConfig = KeychainContainerConfig(keychainName: keychainName, accessGroupName: keychainAccessGroup, lifecycle: currentInstallLifecycle!)
        let nonEquivalentContainer = KeychainStorageContainer<MockUser>(config: nonEquivalentConfig)
        
        XCTAssertEqual(container, equivalentContainer)
        XCTAssertNotEqual(container, nonEquivalentContainer)
    }
    
//    func test_KeychainStorageContainer_HasItem() {
//        let identifier = "hasItemIdentifier"
//        let item = MockUser(name: "hasItem", token: "123")
//        do {
//            try container?.storeItem(item, forIdentifier: identifier)
//
//            let hasItem = container?.hasItem(forIdentifier: identifier) ?? false
//            XCTAssertTrue(hasItem)
//        } catch {
//            XCTFail("\(error)")
//        }
//    }
//
//    func test_KeychainStorageContainer_StoredItem() {
//        let identifier = "storedItemIdentifier"
//        let item = MockUser(name: "storedItem", token: "1234")
//        do {
//            try container?.storeItem(item, forIdentifier: identifier)
//
//            let storedItem = try container?.item(forIdentifier: identifier)
//            XCTAssertEqual(storedItem!, item)
//        } catch {
//            XCTFail("\(error)")
//        }
//    }
//
//    func test_KeychainStorageContainer_RemovedItem() {
//        let identifier = "removedItemIdentifier"
//        let item = MockUser(name: "removedItem", token: "12345")
//        do {
//            try container?.storeItem(item, forIdentifier: identifier)
//
//            try container?.removeItem(forIdentifier: identifier)
//
//            let hasItem = container?.hasItem(forIdentifier: identifier)
//            XCTAssertFalse(hasItem!)
//
//            let storedItem = try container?.item(forIdentifier: identifier)
//            XCTAssertNil(storedItem)
//        } catch {
//            XCTFail("\(error)")
//        }
//    }
//
//    func test_CurrentInstallKeychainStorageContainer_ChangeInstallID() {
//        let identifier = "currentInstallStoredItemIdentifier"
//        let item = MockUser(name: "currentInstallStoredItem", token: "1234")
//        do {
//            try currentInstallContainer?.storeItem(item, forIdentifier: identifier)
//
//            //Check that we can get the item back from the original container
//            let storedItem = try currentInstallContainer?.item(forIdentifier: identifier)
//            XCTAssertEqual(storedItem!, item)
//
//            //Setup a new container using an alternate installation identifier
//            let alternateInstallKeychainLifecycle = KeychainLifecycle.currentInstall(identifier: alternateInstallIdentifier)
//            let alternateInstallKeychainConfig = KeychainContainerConfig(keychainName: currentInstallKeychainName, lifecycle: alternateInstallKeychainLifecycle)
//            let alternateInstallKeychainContainer = KeychainStorageContainer<MockUser>(config: alternateInstallKeychainConfig)
//
//            //Check that the data is no longer accessibile
//            let alternateStoredItem = try alternateInstallKeychainContainer.item(forIdentifier: identifier)
//            XCTAssertNil(alternateStoredItem)
//        } catch {
//            XCTFail("\(error)")
//        }
//    }
}
