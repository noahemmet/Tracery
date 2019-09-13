//
//  Trace.swift
//  
//
//  Created by Noah Emmet on 9/5/19.
//

import Foundation

/// An evaluated grammar.
public struct Trace: Hashable, Codable {
    /// The text and objects that make up this Trace.
    public var segments: [Segment]
    /// The evaluated rules.
    public var rules: [String: String]
    
    public init(_ segments: [Segment], rules: [String: String] = [:]) {
        self.segments = segments
        self.rules = rules
    }
    
    /// The text representation of the Trace.
    public var flattened: String {
        return segments.reduce("") { result, segment in
            switch segment {
            case .object(let object):
                return result + object.result
            case .text(let text):
                return result + text
            }
        }
    }
}

//extension Trace: ExpressibleByStringLiteral {
//    public init(stringLiteral: String) {
//        self.init(text: stringLiteral)
//    }
//}

// MARK: Trace.Segment

extension Trace {
    /// Represents either text or an object. Can be flattened into a single string using `[TextSegment].flattened`.
    public enum Segment: Hashable {
        case text(String)
        case object(Object)
    }
}

extension Trace.Segment: Codable {
    enum CodingKeys: String, CodingKey, Codable {
        case _kind
        case text
        case object
        
        init(_ segment: Trace.Segment) {
            switch segment {
            case .text: self = .text
            case .object: self = .object
            }
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: CodingKeys = try container.decode(CodingKeys.self, forKey: ._kind)
        switch kind {
        case ._kind:
            throw ParserError.error("__kind should never be encoded for \(type(of: self))")
        case .text:
            let text = try container.decode(String.self, forKey: .text)
            self = .text(text)
        case .object:
            let object = try container.decode(Object.self, forKey: .object)
            self = .object(object)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(CodingKeys(self), forKey: ._kind)
        switch self {
        case .text(let text):
            try container.encode(text, forKey: .text)
        case .object(let object):
            try container.encode(object, forKey: .object)
        }
    }
}
