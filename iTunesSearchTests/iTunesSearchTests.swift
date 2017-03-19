//
//  iTunesSearchTests.swift
//  iTunesSearchTests
//
//  Created by Alagu Karthik Prabhu on 04/02/17.
//  Copyright © 2017 kp Alagu. All rights reserved.
//

import XCTest
@testable import iTunesSearch

class iTunesSearchTests: XCTestCase {
    var done:Bool = false
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_should_instantiate_HomeViewController() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let storyboard = UIStoryboard(name: HomeViewController.storyboardName, bundle: nil)
        
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewControllerID") as! HomeViewController
        
        XCTAssertNotNil(homeViewController,"should instantiate HomeViewController")
    }
    
    func test_should_instantiate_EntitySearchResultsViewController() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let entitySearchResultsViewController = storyboard.instantiateViewController(withIdentifier: "EntitySearchResultsViewControllerID") as! EntitySearchResultsViewController
        XCTAssertNotNil(entitySearchResultsViewController,"should instantiate EntitySearchResultsViewController")
    }
    
    func test_should_contain_iTunesSearchValue_when_call_searchAPI()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let entitySearchResultsViewController = storyboard.instantiateViewController(withIdentifier: "EntitySearchResultsViewControllerID") as! EntitySearchResultsViewController
        entitySearchResultsViewController.didSelectedEntity(entity: "movie")
        entitySearchResultsViewController.getiTunesSearchEntityResults(userEnteredText: "john")
        wait(forCompletion: 5)
        XCTAssertTrue(entitySearchResultsViewController.iTunesEntities.count>0, "should contain itunes search result")
        
    }
    
    func test_should_not_contain_iTunesSearchValue_for_invalid_keyword_call_searchAPI()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let entitySearchResultsViewController = storyboard.instantiateViewController(withIdentifier: "EntitySearchResultsViewControllerID") as! EntitySearchResultsViewController
        entitySearchResultsViewController.didSelectedEntity(entity: "movie")
        entitySearchResultsViewController.getiTunesSearchEntityResults(userEnteredText: "dfsdf")
        wait(forCompletion: 5)
        XCTAssertTrue(entitySearchResultsViewController.iTunesEntities.count  == 0, "should contain itunes search result")
        
    }
    func test_should_download_image()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let entitySearchResultsViewController = storyboard.instantiateViewController(withIdentifier: "EntitySearchResultsViewControllerID") as! EntitySearchResultsViewController
        entitySearchResultsViewController.didSelectedEntity(entity: "movie")
        entitySearchResultsViewController.getiTunesSearchEntityResults(userEnteredText: "jack")
        wait(forCompletion: 5)
        let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        entitySearchResultsViewController.startImageDownloaderForIndexPath(indexPath: indexPath)
        wait(forCompletion: 5)
        XCTAssertNotNil(entitySearchResultsViewController.iTunesEntities[0].artworkUrl60Image,"should contain itunes search result")
        
    }
    
    func test_should_instantiate_EntityTypesModalViewController()  {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        
        let entityTypesModalViewController = storyboard.instantiateViewController(withIdentifier: "EntityTypesModalViewControllerID") as! EntityTypesModalViewController
        XCTAssertNotNil(entityTypesModalViewController,"should instantiate EntityTypesModalViewController")
        
    }
    
    func test_should_instantiate_EntityDetailViewController()  {
        
        XCTAssertNotNil(EntityDetailViewController.detailViewControllerForEntity(itunesEntityModel: iTunesEntityModel()),"should instantiate EntityDetailViewController")
        
    }
    
    
    func test_should_notCrash_when_selecting_entity()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let entitySearchResultsViewController = storyboard.instantiateViewController(withIdentifier: "EntitySearchResultsViewControllerID") as! EntitySearchResultsViewController
        entitySearchResultsViewController.didSelectedEntity(entity: "movie")
        XCTAssertTrue(true)
        
    }
    
    func wait(forCompletion timeoutSecs: TimeInterval) {
        let timeoutDate = Date(timeIntervalSinceNow: timeoutSecs)
        repeat {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: timeoutDate)
            if timeoutDate.timeIntervalSinceNow < 0.0 {
                break
            }
        } while !done
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
