//
//  Object.swift
//  
//
//  Created by Noah Emmet on 9/5/19.
//

import Foundation

public struct Object: Codable, Hashable {
    public var name: String
    public var result: String

    public init(name: String, result: String) {
        self.name = name
        self.result = result
    }
}
