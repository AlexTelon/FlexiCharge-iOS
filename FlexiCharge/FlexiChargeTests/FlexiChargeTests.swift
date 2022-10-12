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

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }

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
    
    func testRegisterUser(){
        let _email = "gran@sharklasers.com"
        let _password = "Graaaaan123."
        let expectedResult = "An account with the given email already exists."
        var _result = ""
        print("Testing register user")
        _result = registerAccount(email: _email, password: _password)
        print(_result)
        XCTAssertEqual(expectedResult, _result)

    }
    func testValidPassword(){
        XCTAssertEqual(validatePassword(password: "Graaaaaaan1."), "")
    }
    
    func testValidEmail(){
        XCTAssertEqual(validateEmail(email: "gran@sharklasers.com"), "")
    }
    func testValidVerificationCode(){
        XCTAssertEqual(validateVerificationCode(verificationCode: "123456"), "")
    }
    
    func testPasswordNotEmpty(){
        XCTAssertEqual(passwordNotEmpty(input: "notEmpty"), "")
    }
}
