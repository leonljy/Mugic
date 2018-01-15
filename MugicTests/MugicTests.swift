//
//  MugicTests.swift
//  MugicTests
//
//  Created by Jeong-Uk Lee on 2018. 1. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import XCTest
@testable import Mugic

import AudioKit

class MugicTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreatePiano() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let piano = Hit(bass: .C, detail: .Maj, amplitude: 0.5)
        
        piano.play()
        sleep(1)
        piano.stop()
        
        XCTAssertNotNil(piano)
    }
    
    
}
