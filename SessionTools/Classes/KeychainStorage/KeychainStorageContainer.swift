//
//  KeychainStorageContainer.swift
//  SessionTools
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import Foundation
import KeychainAccess

/// A config for creating a name to use for a 'Keychain' instance.
public struct KeychainContainerConfig: Equatable {
    let keychainName: String
    let accessGroupName: String?
    
    public init(keychainName: String, accessGroupName: String? = nil) {
        self.keychainName = keychainName
        self.accessGroupName = accessGroupName
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
