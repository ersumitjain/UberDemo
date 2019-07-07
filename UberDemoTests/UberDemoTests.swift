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
    
    var viewModel: UBPhotoVM?
    var expectation: XCTestExpectation?
    var request: UBRequest!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
         request = UBRequest.from(text: "kittens")
        viewModel = UBPhotoVM(request: request, delegate: self)
    }
    
    func testValidCallToGetStatusCode200() {
        let promise = expectation(description: "Status code: 200")
        viewModel?.client.fetchPhotos(with: request, page: 1){ result in
            switch result {
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
                return
            case .success(_):
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 40)
    }
    
    func testListSuccess(){
        XCTAssertTrue(viewModel?.currentCount == 0)
        expectation = self.expectation(description: "Response")
        viewModel?.fetchPhotos()
        waitForExpectations(timeout: 40, handler: nil)
        XCTAssertTrue((viewModel?.totalCount)! > 0)
        XCTAssertTrue((viewModel?.currentCount)! > 1)
    }
    
    func testListfailure(){
        request = UBRequest.from(text: "kittexzxzxzxns")
        viewModel = UBPhotoVM(request: request, delegate: self)
        expectation = self.expectation(description: "Response")
        viewModel?.fetchPhotos()
        waitForExpectations(timeout: 40, handler: nil)
        XCTAssertFalse((viewModel?.totalCount)! > 0)
        XCTAssertFalse((viewModel?.currentCount)! > 1)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
}
extension UberDemoTests: PhotoVMDelegate{
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        expectation?.fulfill()
    }
    
    func onFetchFailed(with reason: String) {
        expectation?.fulfill()
    }
}
