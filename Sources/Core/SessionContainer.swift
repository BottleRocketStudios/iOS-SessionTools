//
//  SessionContainer.swift
//  SessionTools
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import Foundation

/// Represents something capable of storing, retrieving, and removing items using a key-value relationship.
public protocol SessionContainer {
    associatedtype Item
    
    func hasItem(forIdentifier identifier: String) -> Bool
    func item(forIdentifier identifier: String, jsonDecoder: JSONDecoder) throws -> Item?
    func removeItem(forIdentifier identifier: String) throws
    func storeItem(_ item: Item, forIdentifier identifier: String, jsonEncoder: JSONEncoder) throws
}

/// Type erasure structure to represent a generice SessionContainer.
public struct AnySessionContainer<T: Codable>: SessionContainer {

    private let _hasItem: (String) -> Bool
    private let _item: (String, JSONDecoder) throws -> T?
    private let _removeItem: (String) throws -> Void
    private let _storeItem: (T, String, JSONEncoder) throws -> Void
    
    // MARK: - Init
    
    public init<U: SessionContainer>(_ sessionContainer: U) where U.Item == T {
        _hasItem = sessionContainer.hasItem
        _item = sessionContainer.item
        _removeItem = sessionContainer.removeItem
        _storeItem = sessionContainer.storeItem
    }
    
    // MARK: - SessionContainer
    
    public func hasItem(forIdentifier identifier: String) -> Bool {
        return _hasItem(identifier)
    }
    
    public func item(forIdentifier identifier: String, jsonDecoder: JSONDecoder) throws -> T? {
        return try _item(identifier, jsonDecoder)
    }
    
    public func removeItem(forIdentifier identifier: String) throws {
        try _removeItem(identifier)
    }
    
    public func storeItem(_ item: T, forIdentifier identifier: String, jsonEncoder: JSONEncoder) throws {
        try _storeItem(item, identifier, jsonEncoder)
    }
}
