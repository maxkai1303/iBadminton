//
//  iBadmintonTests.swift
//  iBadmintonTests
//
//  Created by Max Kai on 2020/12/31.
//

import XCTest
@testable import iBadminton

class IBadmintonTests: XCTestCase {
    
    var double: Double?
    
    override func setUpWithError() throws {
        super.setUp()
        // 測試模組要執行前會先執行的部份
        double = Double()
    }

    override func tearDownWithError() throws {
        // 每一個測試模組執行後要執行的
    }

//    func testExample() throws {
//        // 測試模組，一定要用 test 開頭
//    }
    
//    func testPerformanceExample() throws {
//        // 測試效能的
//        measure { }
//    }
    
    func testNormal() throws {
        let item = 3.1415
        let roundedItem = item.rounding(toDecimal: 3)
        XCTAssertEqual(roundedItem, 3.142)
    }
    
    func testBad() throws {
        let item = 3.1415
        let roundedItem = item.rounding(toDecimal: 0)
        XCTAssertEqual(roundedItem, 3)
    }
    
    func testZero() throws {
        let item = 0.0000
        let roundedItem = item.rounding(toDecimal: 5)
        XCTAssertEqual(roundedItem, 0)
        
    }
    
    func testMinus() throws {
        let item = -3.1415
        let roundedItem = item.rounding(toDecimal: 2)
        XCTAssertEqual(roundedItem, -3.14)
    }
    
    func testDecimal() throws {
        let item = 0.5534
        let roundedItem = item.rounding(toDecimal: 1)
        XCTAssertEqual(roundedItem, 0.6)
    }
}
