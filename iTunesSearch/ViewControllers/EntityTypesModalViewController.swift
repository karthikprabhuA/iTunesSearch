//
//  EnityTypesModalViewController.swift
//  iTunesSearch
//
//  Created by Alagu Karthik Prabhu on 04/02/17.
//  Copyright © 2017 kp Alagu. All rights reserved.
//

import UIKit
protocol EntityTypesModalViewControllerDelegate {
    func didSelectedEntity(entity:String)
}
class EntityTypesModalViewController: UITableViewController {
    let entityTypes = ["musicVideo", "audiobook", "shortFlim", "tvShow", "software", "ebook"]
    static let entityTypeCellIdentifier = "entityTypeCellID"
    var selectedIndex:Int?
    var delegate:EntityTypesModalViewControllerDelegate?;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entityTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EntityTypesModalViewController.entityTypeCellIdentifier, for: indexPath)
        cell.textLabel?.text = entityTypes[indexPath.row];
        if (selectedIndex == indexPath.row)
        {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none;
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedCell = tableView.cellForRow(at: indexPath)
        if  selectedIndex != nil
        {
            let previouslySelectedIndexPath = IndexPath(row: self.selectedIndex!, section: indexPath.section)
            self.selectedIndex = indexPath.row
            self.tableView.reloadRows(at: [previouslySelectedIndexPath as IndexPath], with: UITableViewRowAnimation.none)
        }
        else
        {
            self.selectedIndex = indexPath.row
        }
        selectedCell?.accessoryType = UITableViewCellAccessoryType.checkmark
        self.delegate?.didSelectedEntity(entity: entityTypes[selectedIndex!])
        self .dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self .dismiss(animated: true, completion: nil)
    }
    
    
    
}
