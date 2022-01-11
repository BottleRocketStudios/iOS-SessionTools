//
//  MockStorageContainer.swift
//  SessionTools-iOSTests
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import Foundation
import SessionTools

/// An in memory container for testing.
class MockStorageContainer<T: Codable>: SessionContainer {
    
    private var localStorage = [String: Data]()
    
    func hasItem(forIdentifier identifier: String) -> Bool {
        return localStorage[identifier] != nil
    }
    
    func item(forIdentifier identifier: String, jsonDecoder: JSONDecoder = JSONDecoder()) throws -> T? {
        guard let itemData = localStorage[identifier] else { return nil }
        return try? jsonDecoder.decode(T.self, from: itemData)
    }
    
    func removeItem(forIdentifier identifier: String) throws {
        localStorage.removeValue(forKey: identifier)
    }
    
    func storeItem(_ item: T, forIdentifier identifier: String, jsonEncoder: JSONEncoder = JSONEncoder()) throws {
        let itemData = try jsonEncoder.encode(item)
        localStorage[identifier] = itemData
    }
}
