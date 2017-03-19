//
//  HomeViewController.swift
//  iTunesSearch
//
//  Created by Alagu Karthik Prabhu on 04/02/17.
//  Copyright © 2017 kp Alagu. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    
    /// Search controller to help us with filtering
    var searchController: UISearchController!
    
    /// Secondary search results table view.
    var resultsTableController: EntitySearchResultsViewController!
    
    // MARK: - Types
    
    // Constants for Storyboard and ViewController
    static let storyboardName = "Main"
    static let entityModalNavigationControllerIdentifier = "EnityTypesModalViewControllerID"
    
    // MARK: lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "iTunesSearch"
        controllerInitialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init
    /**
     *Initialize searchcontroller and result table controller
     */
    func controllerInitialization()
    {
        resultsTableController = EntitySearchResultsViewController()
        resultsTableController.homeViewController = self
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = resultsTableController
        searchController.searchBar.sizeToFit()
        resultsTableController.searchBar = searchController.searchBar
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = entityTypes
        tableView.tableHeaderView =  searchController.searchBar
        searchController.delegate = resultsTableController
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        searchController.searchBar.delegate = resultsTableController    // so we can monitor text changes + others
        definesPresentationContext = true
    }
    
    
     /**
     *Not showing anything on this tableview
     */

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntityTableViewCellID", for: indexPath) as! EntityTableViewCell
        return cell
    }
    
    
    
}

