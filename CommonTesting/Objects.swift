//
//  Objects.swift
//  Tracery
//
//  Created by Benzi on 26/03/17.
//  Copyright © 2017 Benzi Ahamed. All rights reserved.
//

import XCTest
@testable import Tracery

class Objects: XCTestCase {
    
    func testAllowAddingObjects() {
        let t = Tracery()
        t.add(object: "jack", named: "person")
        
        XCTAssertEqual(t.expand("#person#"), "jack")
    }
    
    func testAllowAddingObjectsWithSegments() {
        let t = Tracery()
        t.add(object: "jack", named: "person")
        let trace = t.expandSegments("hi my name is #person#, nice to meet you.")
        XCTAssertEqual(trace.segments, [.text("hi my name is "), .object(name: "person", result: "jack"), .text(", nice to meet you.")])
        XCTAssertEqual(trace.flattened, "hi my name is jack, nice to meet you.")
    }
    
    func testObjectsCanRunModifiers() {
        let t = Tracery()
        t.add(object: "jack", named: "person")
        t.add(modifier: "caps") { $0.uppercased() }
        
        XCTAssertEqual(t.expand("#person.caps#"), "JACK")
    }
    
    func testNotFoundObjectsAreNotExpanded() {
        let t = Tracery()
        t.add(object: "jack", named: "person")
        XCTAssertEqual(t.expand("#person1#"), "{person1}")
    }
    
    func testObjectsCanBeAccessedFromDynamicRules() {
        let t = Tracery()
        t.add(object: "jack", named: "person")
        XCTAssertEqual(t.expand("#msg(#person# is here\\.)##msg#"), "jack is here.")
    }
    
}
