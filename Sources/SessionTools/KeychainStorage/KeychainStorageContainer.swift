//
//  KeychainStorageContainer.swift
//  SessionTools
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import Foundation
import KeychainAccess

/// The lifecycle of the keychain item's data
public enum KeychainLifecycle: Equatable {
    /// Default case - The framework will make no attempt to remove the session's data on your behalf and you will be responsible for removing this session's data by calling `Session.deleteItem()` when needed. Because of differences between OS versions, we cannot make any guarantees on how long the data will persist in the keychain beyond the current install.
    case unmanaged
    
    /// The session will only persist for the current installation identifier. It does this by prepending the installation identifier to the keychain key. You could still get the data back by reusing a previous installation identifier, but because of differences between OS versions, we cannot make any guarantees on how long the data will persist in the keychain beyond the current install.
    /// - identifier: A unique identifier for the installation. This identifier should remain stable for the current installation but change between installations.
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
