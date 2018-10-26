//
//  TheMovieAppTests.swift
//  TheMovieAppTests
//
//  Created by Luis Cabarique on 10/24/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import XCTest
import Moya
import RxBlocking
import RxTest
import RxSwift

class TheMovieAppTests: XCTestCase {
    
    var vm: MediaMainViewModel!
    
    override func setUp() {
        super.setUp()
        theMovieDBAPI = MoyaProvider<theMovieDBEndPoints>(stubClosure: MoyaProvider.immediatelyStub)
        vm = MediaMainViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        vm = nil
    }
    
    func testExample() {
        let blocking = vm.mediaSectionObservable
            .observeOn(MainScheduler.instance)
            .toBlocking(timeout: 10)
        do {
            let medias = try blocking.first()!
            XCTAssertEqual(medias.count, 6)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        
    }
}
