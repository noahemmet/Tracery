//
//  Trace.swift
//  
//
//  Created by Noah Emmet on 9/5/19.
//

import Foundation

public struct Trace: Hashable {
    public var segments: [Segment]

    public init(_ segments: [Segment]) {
        self.segments = segments
    }
    
    public var flattened: String {
        return segments.reduce("") { result, segment in
            switch segment {
            case .object(_, let objectResult):
                return result + objectResult
            case .text(let text):
                return result + text
            }
        }
    }
}

extension Trace {
    /// Represents either text or an object. Can be flattened into a single string using `[TextSegment].flattened`.
    public enum Segment: Hashable {
        case text(String)
        case object(name: String, result: String)
    }
}
