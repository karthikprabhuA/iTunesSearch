//
//  EntitySearchResultsViewController.swift
//  iTunesSearch
//
//  Created by Alagu Karthik Prabhu on 04/02/17.
//  Copyright © 2017 kp Alagu. All rights reserved.
//

import UIKit

class EntitySearchResultsViewController: UITableViewController ,EntityTypesModalViewControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating,HttpConnectionDelegate{
    
    // MARK: - Properties
    weak var homeViewController: UITableViewController?
    weak var searchBar: UISearchBar?
    
    var entityModalNavigationController:UINavigationController!
    var httpConnection:HttpConnection?
    var userSelectedEntity:String?
    /// Data model for the table view.
    var iTunesEntities = [iTunesEntityModel]()
    var searchResultMessage:String?
    var imageDownloaderInProgress:[ImageDownloader]?;
    // MARK: - Types
    static let resultTableCellIdentifier = "EntityTableViewCellID"
    static let resultTableNibName = "EntityTableViewCell"
    static let noResultTableCellIdentifier = "EntityNoResultsTableViewCellID"
    static let noResultTableNibName = "EntityNoResultsTableViewCell"
    let tableCellRowHeight:CGFloat = 70
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerInitialization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        cancelAllImageDownloads()
    }
    
    //MARK: - Init
    /**
     * Initialize nib files and register tableviewcells
     */
    func controllerInitialization()
    {
        self.userSelectedEntity = entityTypes[0] //default Entity selection
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // Required if our subclasses are to use `dequeueReusableCellWithIdentifier(_:forIndexPath:)`.
        let nib = UINib(nibName: EntitySearchResultsViewController.resultTableNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: EntitySearchResultsViewController.resultTableCellIdentifier)
        let noResultNib = UINib(nibName: EntitySearchResultsViewController.noResultTableNibName, bundle: nil)
        tableView.register(noResultNib, forCellReuseIdentifier: EntitySearchResultsViewController.noResultTableCellIdentifier)
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(iTunesEntities.count == 0)
        {
            return 1;
        }
        return iTunesEntities.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(iTunesEntities.count == 0) // show search results status when count is zero
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: EntitySearchResultsViewController.noResultTableCellIdentifier, for: indexPath)
            cell.textLabel?.text = searchResultMessage
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EntitySearchResultsViewController.resultTableCellIdentifier, for: indexPath) as! EntityTableViewCell
        cell.configureCell(cell: cell, forEntity: iTunesEntities[indexPath.row])
        
        if(iTunesEntities[indexPath.row].artworkUrl60Image == nil)
        {
            //Don't download when scroll in progress
            if (self.tableView.isDragging == false && self.tableView.isDecelerating == false)
            {
                startImageDownloaderForIndexPath(indexPath: indexPath)
            }
            //show a placeholder image when download in progress
            cell.artWork60.image = UIImage(named:placeHolderImageName)
        }
        else
        {
            //show the cached image
            cell.artWork60.image =  iTunesEntities[indexPath.row].artworkUrl60Image
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableCellRowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectediTunesEntity: iTunesEntityModel = iTunesEntities[indexPath.row]
        let detailViewController = EntityDetailViewController.detailViewControllerForEntity(itunesEntityModel: selectediTunesEntity)
        homeViewController?.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
    // MARK: -   EntityTypesModalViewControllerDelegate
    /**
     * This mehtod gets Called when user selected more Modal popover Entity type
     * Make new service call with the selected entity and cancel all the image downloads in progress
     * @param entity selected entity type
     */
    func didSelectedEntity(entity:String)
    {
        self.userSelectedEntity = entity
        if(self.searchBar != nil)
        {
            makeiTunesSearchServiceCall(searchBar: self.searchBar!)
        }
        cancelAllImageDownloads()
    }
    
    // MARK: - iTunesSearch Events
    /**
    * Make new iTunes search service call and Cancel the existing image download
    * @param searchbar searchBar to get the user entered text
    */
    func makeiTunesSearchServiceCall(searchBar:UISearchBar){
        searchBar.resignFirstResponder()
        self.iTunesEntities.removeAll()
        cancelAllImageDownloads()
        let trimmedString = searchBar.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        getiTunesSearchEntityResults(userEnteredText: trimmedString)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        makeiTunesSearchServiceCall(searchBar: searchBar)
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        if(self.entityModalNavigationController == nil)
        {
            //show detailed viewcontroller
            let storyboard = UIStoryboard(name: HomeViewController.storyboardName, bundle: nil)
            self.entityModalNavigationController = storyboard.instantiateViewController(withIdentifier: HomeViewController.entityModalNavigationControllerIdentifier) as! UINavigationController
            self.entityModalNavigationController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            let entityModalViewController = self.entityModalNavigationController.viewControllers[0] as! EntityTypesModalViewController
            entityModalViewController.delegate   = self
        }
        if(searchBar.selectedScopeButtonIndex != -1) //set the selected index
        {
            self.userSelectedEntity = entityTypes[searchBar.selectedScopeButtonIndex]
        }
        if(selectedScope != 3 && selectedScope >= 0)
        {
            makeiTunesSearchServiceCall(searchBar: searchBar) //Make new service when user change the Entity type
        }
            //show all entity type selection viewcontroller when user select more
        else if selectedScope == 3 {
            searchBar.selectedScopeButtonIndex = -1;
            homeViewController?.navigationController?.present(entityModalNavigationController, animated: true)
        }
        
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController)
    {
    }
    
    // MARK: - iTunes Search API
    /**
    * create httpConnection connection and request data for the selected entity and user entered search text
    * @param userEnteredText user entered search text
    */
    func getiTunesSearchEntityResults(userEnteredText:String)
    {
        if (userEnteredText.isEmpty == false){
            if  httpConnection == nil
            {
                httpConnection = HttpConnection();
                httpConnection?.delegate = self;
            }
            var itunesSearchURLString = iTunesSearchAPI.replacingOccurrences(of:",", with: userEnteredText)
            itunesSearchURLString = itunesSearchURLString.replacingOccurrences(of:"!", with: self.userSelectedEntity!)
            self.searchResultMessage = NSLocalizedString("Loading", comment: "")
            httpConnection?.getDataForURLString(urlString: itunesSearchURLString)
        }
    }
    //MARK: HTTPConnection Delegate
    func didReceiveData(data:Data,forURLString:String)
    {
        //call parser to parse the response JSON data
        let entityParser = EntityListParser.init(data: data);
        if(self.iTunesEntities.count > 0) //clear all existing values
        {
            self.iTunesEntities.removeAll()
        }
        self.iTunesEntities = entityParser.iTunesEntityModels; //assign the parsed json entity models
        checkAndSetSearchResultMessage()
        self.tableView.reloadData()
    }
    
    func didReceiveDataFailure(error:Error)
    {
        checkAndSetSearchResultMessage()
        showAlert(title: applicationName,message: error.localizedDescription)
    }
    
    // MARK: ImageDownloader
    /*
     * Create new ImageDownloader instance and start image downloader, get the image data from the ImageDownloader completion handler
     * Store the imageDownloader instance in imageDownloaderInProgress to avoid repeated dwonloads
     * cache the downloaded Image
     *
     * @param indexPath indexpath to download
     */
    func startImageDownloaderForIndexPath(indexPath:IndexPath)  {
        var imageDownloader = imageDownloaderInProgress?[indexPath.row]
        if(imageDownloader == nil)
        {
            imageDownloader = ImageDownloader()
            imageDownloader?.imageData = (self.iTunesEntities[indexPath.row] as iTunesEntityModel).artworkUrl60Image
            imageDownloader?.completionHandler = {
                () -> Void in
                if let cell:EntityTableViewCell = self.tableView.cellForRow(at: indexPath) as? EntityTableViewCell
                {
                    if(self.iTunesEntities.count > 0)
                    {
                        self.iTunesEntities[indexPath.row].artworkUrl60Image = imageDownloader?.imageData
                        cell.artWork60.image = imageDownloader?.imageData
                        self.imageDownloaderInProgress?.remove(at: indexPath.row)
                    }
                }
            }
        }
        self.imageDownloaderInProgress?[indexPath.row] = imageDownloader!
        if(self.iTunesEntities.count > 0)
        {
            if let imageURLString = self.iTunesEntities[indexPath.row].artworkUrl60
            {
                imageDownloader?.startDownloadWithURLString(urlString:imageURLString )
            }
        }
        
    }
    /**
     * Start ImageDownloader only for the visible tableview cells
     */
    func loadImagesOnlyForVisibleCellRows()
    {
        if (self.iTunesEntities.count > 0)
        {
            let visiblePaths = self.tableView.indexPathsForVisibleRows
            for indexPath in visiblePaths! {
                if(self.iTunesEntities[indexPath.row].artworkUrl60Image == nil)
                {
                    startImageDownloaderForIndexPath(indexPath: indexPath)
                }
            }
        }
        
    }
    /**
     * Cancel all ImageDownloader in progress
     */
    func cancelAllImageDownloads()
    {
        if(self.imageDownloaderInProgress != nil && (self.imageDownloaderInProgress?.count)! > 0)
        {
            for imageDownloader in self.imageDownloaderInProgress!
            {
                imageDownloader.cancelDownload()
            }
            self.imageDownloaderInProgress?.removeAll()
        }
    }
    
    
    // MARK: Message settings
    func checkAndSetSearchResultMessage()
    {
        if(self.iTunesEntities.count == 0)
        {
            self.searchResultMessage = NSLocalizedString("NoResultsFound", comment: "")
        }
        else
        {
            self.searchResultMessage = "";
        }
    }
    // MARK: Alerts
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Scrollview Delegate
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if (!decelerate)
        {
            loadImagesOnlyForVisibleCellRows()
        }
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) // called when scroll view grinds to a halt
    {
        loadImagesOnlyForVisibleCellRows()
    }
    
    // MARK: Deinit
    deinit {
        cancelAllImageDownloads()
    }
}
