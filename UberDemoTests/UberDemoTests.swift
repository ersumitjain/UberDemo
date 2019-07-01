//
//  UberDemoTests.swift
//  UberDemoTests
//
//  Created by Sumit Jain on 02/07/19.
//  Copyright © 2019 Sumit Jain. All rights reserved.
//

import XCTest
@testable import UberDemo

class UberDemoTests: XCTestCase {
    
    var viewModel: UBListVM?
    var expectation: XCTestExpectation?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testListSuccess(){
        let request = UBRequest.from(text: "kittens")
        viewModel = UBListVM(request: request, delegate: self)
        XCTAssertTrue(viewModel?.currentCount == 0)
        expectation = self.expectation(description: "Response")
        viewModel?.fetchPhotos()
        waitForExpectations(timeout: 40, handler: nil)
        XCTAssertTrue((viewModel?.totalCount)! > 0)
        XCTAssertTrue((viewModel?.currentCount)! > 1)
    }
    
    func testListfailure(){
        let request = UBRequest.from(text: "kittexzxzxzxns")
        viewModel = UBListVM(request: request, delegate: self)
        expectation = self.expectation(description: "Response")
        viewModel?.fetchPhotos()
        waitForExpectations(timeout: 40, handler: nil)
        XCTAssertFalse((viewModel?.totalCount)! > 0)
        XCTAssertFalse((viewModel?.currentCount)! > 1)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
extension UberDemoTests: ListVMDelegate{
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        expectation?.fulfill()
    }
    
    func onFetchFailed(with reason: String) {
        expectation?.fulfill()
    }
}
