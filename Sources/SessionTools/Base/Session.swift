//
//  Session.swift
//  SessionTools
//
//  Copyright © 2018 Bottle Rocket Studios. All rights reserved.
//

import Foundation

/// A base class for creating something that can store, retrieve, and delete an item in a `SessionContainer`. Can post notifications by providing something conforming to `NotificationPosting`.
open class Session<T: Codable> {
    
    public let container: AnySessionContainer<T>
    public let storageIdentifier: String
    public let notificationPoster: NotificationPosting?
    public let encoder: JSONEncoder
    public let decoder: JSONDecoder
    
    public init(container: AnySessionContainer<T>, storageIdentifier: String, notificationPoster: NotificationPosting? = nil, itemEncoder: JSONEncoder = JSONEncoder(), itemDecoder: JSONDecoder = JSONDecoder()) {
        self.container = container
        self.storageIdentifier = storageIdentifier
        self.notificationPoster = notificationPoster
        self.encoder = itemEncoder
        self.decoder = itemDecoder
    }
    
    // MARK: - Item Management
    
    public var hasItem: Bool {
        return container.hasItem(forIdentifier: storageIdentifier)
    }
    
    public var currentItem: T? {
        guard let user = try? container.item(forIdentifier: storageIdentifier, jsonDecoder: decoder) else { return nil }
        return user
    }
    
    public func updateItem(_ model: T?) throws {
        guard let model = model else { return }
        try container.storeItem(model, forIdentifier: storageIdentifier, jsonEncoder: encoder)
    }
    
    public func deleteItem() throws {
        try container.removeItem(forIdentifier: storageIdentifier)
    }
}
