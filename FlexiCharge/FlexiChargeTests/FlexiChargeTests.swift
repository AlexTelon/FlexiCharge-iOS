//
//  FlexiChargeTests.swift
//  FlexiChargeTests
//
//  Created by Filip Flodén on 2021-09-06.
//

import XCTest
@testable import FlexiCharge

class FlexiChargeTests: XCTestCase {
    
    var accountApiModel = AccountAPI()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testRegisterUser() throws {
        
        
        
        accountApiModel.registerAccount(username: "Bob1337", password: "Kalleballe123.", email: "sandranissan@outlook.com", firstName: "Sandra", surName: "Nissan"){ someData in
            print("AccountApiModel is done")
            print(someData)
            
        }
        
    }

}
