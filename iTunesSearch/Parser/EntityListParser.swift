//
//  EntityListParser.swift
//  iTunesSearch
//
//  Created by Alagu Karthik Prabhu on 05/02/17.
//  Copyright © 2017 kp Alagu. All rights reserved.
//

import Foundation

class EntityListParser
{
var iTunesEntityModels = [iTunesEntityModel]()

    /**
     * Initialize and Parse the JSON to create iTunesEntityModel array
     * @data JSON data
     */
init(data:Data) {
    do {
        let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        if let entityLists:[NSDictionary] = parsedData["results"] as! [NSDictionary]?
        {
            //TO DO :- Should parse the data for specific entity since only few values are common to all Entity
            for entityData in entityLists {
                let trackName = entityData.value(forKey: "trackName" ) as? String
                let artwork60 = entityData.value(forKey: "artworkUrl60" ) as? String
                let artistName = entityData.value(forKey: "artistName" ) as? String
                let artwork100 = entityData.value(forKey: "artworkUrl100" ) as? String
                var price:String = "NA"
               if let collectionPrice = (entityData.value(forKey: "collectionPrice" ) as? Double)
               {
                 price =  String(format:"%.2f", collectionPrice)
               }
                let collectionName = entityData.value(forKey: "collectionName" ) as? String
                iTunesEntityModels.append(iTunesEntityModel(trackName: trackName, artworkUrl60: artwork60,artworkUrl100:artwork100, price: price, shortDescription: artistName, longDescription: collectionName,artworkUrl60Image:nil))
            }
        }
        
    }
    catch {
        print("JSON Processing Failed")
    }
}
}
