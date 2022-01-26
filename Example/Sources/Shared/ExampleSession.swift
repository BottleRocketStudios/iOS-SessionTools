//
//  ExampleSession.swift
//  Example
//
//  Copyright (c) 2018 Bottle Rocket Studios. All rights reserved.
//

import Foundation
import SessionTools

/// A simple model with an identifier.
struct ExampleModel: Codable {
    let identifier: String
    var numberOfTimesRefreshed = 0
}

/// A Session that can be refreshed.
class ExampleSession: Session<ExampleModel>, Refreshable {
    
    // MARK: - SessionRefreshable
    
    func refresh(completion: @escaping RefreshCompletion) {
        var model = currentItem
        model?.numberOfTimesRefreshed += 1
        try? updateItem(model)
        completion(nil)
    }
}
