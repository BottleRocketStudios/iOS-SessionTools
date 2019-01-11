//
//  Refreshable.swift
//  SessionTools
//
//  Copyright (c) 2018 Bottle Rocket Studios. All rights reserved.
//

import Foundation

public typealias RefreshCompletion = (_ error: RefreshError?) -> Void
public typealias RefreshAllCompletion = (_ errors: [RefreshError]?) -> Void
public typealias RefreshHandler = (_ completion: @escaping RefreshCompletion) -> Void

/// A simple refresh strategy you can use to determine when a refresh should occur.
public enum RefreshStrategy {
    case always
    case ifNeeded
    case never
}

/// Represents an error value for a RefreshCompletion closure.
public enum RefreshError: Error {
    case noToken
    case unableToRefresh(error: Error)
}

/// Provides functionality for refreshing something.
public protocol Refreshable {
    func refresh(completion: @escaping RefreshCompletion)
}

// Conditional extension to refresh all elements in an array.
extension Sequence where Iterator.Element == Refreshable {
   
    public func refresh(completion: @escaping RefreshAllCompletion) {
        let dispatchGroup = DispatchGroup()
        var refreshErrors: [RefreshError] = []
        
        forEach { session in
            dispatchGroup.enter()
            session.refresh(completion: { (error) in
                if let error = error {
                    refreshErrors.append(error)
                }
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(refreshErrors.isEmpty ? nil : refreshErrors)
        }
    }
}
