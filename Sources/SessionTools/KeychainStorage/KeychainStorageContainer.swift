//
//  KeychainStorageContainer.swift
//  SessionTools
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import Foundation
import KeychainAccess

/// The lifecycle of the keychain item added
public enum KeychainLifecycle: Equatable {
    /// Default case - it's up to you and the OS rules to define when this session is deleted
    case unmanaged
    
    /// The session will only live in the current installation - a delete and reinstall will make this item unreachable.
    /// - identifier: A unique identifier for the installation. It should remain stable between installations.
    case currentInstall(identifier: String)
}

/// A config for creating a name to use for a 'Keychain' instance.
public struct KeychainContainerConfig: Equatable {
    let keychainName: String
    let accessGroupName: String?
    let keychainLifecycle: KeychainLifecycle
    
    public init(keychainName: String, accessGroupName: String? = nil, lifecycle: KeychainLifecycle = .unmanaged) {
        let internalKeychainName: String
        switch lifecycle {
        case .currentInstall(let installationIdentifier):
            //If we're using an install lifecycle, append the install ID to the keychain name
            internalKeychainName = installationIdentifier + keychainName
        case .unmanaged:
            //Otherwise, just set the name as it's unmanaged
            internalKeychainName = keychainName
        }
        
        self.keychainName = internalKeychainName
        self.accessGroupName = accessGroupName
        self.keychainLifecycle = lifecycle
    }
}

/// A conatiner for storing data to the keychain.
public struct KeychainStorageContainer<T: Codable>: SessionContainer {
    
    private let keychain: Keychain
    private let config: KeychainContainerConfig
    
    public init(config: KeychainContainerConfig) {
        self.config = config
        
        if let accessGroupName = config.accessGroupName {
            keychain = Keychain(service: config.keychainName, accessGroup: accessGroupName)
        } else {
            keychain = Keychain(service: config.keychainName)
        }
    }
    
    public func hasItem(forIdentifier identifier: String) -> Bool {
        return keychain[identifier] != nil
    }
    
    public func item(forIdentifier identifier: String, jsonDecoder: JSONDecoder = JSONDecoder()) throws -> T? {
        guard let keychainData = try keychain.getData(identifier) else { return nil }
        return try? jsonDecoder.decode(T.self, from: keychainData)
    }
    
    public func removeItem(forIdentifier identifier: String) throws {
        try keychain.remove(identifier)
    }
    
    public func storeItem(_ item: T, forIdentifier identifier: String, jsonEncoder: JSONEncoder = JSONEncoder()) throws {
        let itemData = try jsonEncoder.encode(item)
        try keychain.set(itemData, key: identifier)
    }
}

extension KeychainStorageContainer: Equatable {
    
    public static func == (lhs: KeychainStorageContainer<T>, rhs: KeychainStorageContainer<T>) -> Bool {
        return lhs.config == rhs.config
    }
}
