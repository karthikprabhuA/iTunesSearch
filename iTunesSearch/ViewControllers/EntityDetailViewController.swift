//
//  EntityDetailViewController.swift
//  iTunesSearch
//
//  Created by Alagu Karthik Prabhu on 04/02/17.
//  Copyright © 2017 kp Alagu. All rights reserved.
//

import UIKit

class EntityDetailViewController: UIViewController,HttpConnectionDelegate {
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artWork100: UIImageView!
    @IBOutlet weak var longDescription: UILabel!
    @IBOutlet weak var price: UIPriceLabel!
    // MARK: - Types
    
    // Constants for Storyboard/ViewControllers.
    static let storyboardName = "Main"
    static let entityDetailViewControllerIdentifier = "EntityDetailViewControllerID"
    var itunesEntityModel: iTunesEntityModel!
    var httpConnection:HttpConnection?

    override func viewDidLoad() {
        super.viewDidLoad()
        trackName.text = itunesEntityModel.trackName
        if itunesEntityModel.longDescription != nil
        {
        longDescription.text = itunesEntityModel.longDescription
        }
        else
        {
            longDescription.text = itunesEntityModel.shortDescription
        }
        price.text = itunesEntityModel.price
        fetchAlbumImage()
        // Do any additional setup after loading the view.
    }

    // MARK: - Image Loading
    func fetchAlbumImage()  {
        httpConnection =  HttpConnection();
        httpConnection?.delegate = self;
        httpConnection?.getDataForURLString(urlString: itunesEntityModel.artworkUrl100!)
    }
    // MARK: - Initialization
    
    class func detailViewControllerForEntity(itunesEntityModel: iTunesEntityModel) -> EntityDetailViewController {
        let storyboard = UIStoryboard(name: EntityDetailViewController.storyboardName, bundle: nil)
        
        let detailViewController = storyboard.instantiateViewController(withIdentifier: EntityDetailViewController.entityDetailViewControllerIdentifier) as! EntityDetailViewController
        detailViewController.itunesEntityModel = itunesEntityModel
        
        return detailViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
           self .dismiss(animated: true, completion: nil)
    }

    func didReceiveData(data:Data,forURLString:String)
    {
        self.artWork100.image = UIImage(data: data)
    }
    func didReceiveDataFailure(error:Error)
    {
        self.artWork100.image = UIImage(named:placeHolderImageName)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
