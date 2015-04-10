//
//  RequestGoogleGeocoding.swift
//  MetroforApp
//
//  Created by Adolfho Athyla on 05/04/15.
//  Copyright (c) 2015 Adolfho Athyla. All rights reserved.
//

import UIKit

class RequestGoogleGeocoding {
    
    var places = [Place]()
    
    func initMySearchWithString(search: String, completeBlock: () -> ()) {
        
        if let urlUTF8 = search.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            var url = "http://maps.googleapis.com/maps/api/geocode/json?address=\(urlUTF8)&sensor=true&region=br"
            
            self.getDataFrom(url, completeBlock: { () -> () in
                completeBlock()
            })
        }
        
    }
    
    private func getDataFrom(url: String, completeBlock: () -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            self.treatMyData(data, completeBlock: { () -> () in
                completeBlock()
            })
            
        }
    }
    
    private func treatMyData(data: NSData, completeBlock: () -> ()) {
        let response = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: nil) as! NSDictionary
        
        let status = response.valueForKey("status") as! String
        
        if status == "OK" {
            
            let result = response.valueForKey("results") as! NSArray
            
            let addresses = result.valueForKey("formatted_address") as! NSArray
            
            let locations = response.valueForKey("results")?.valueForKey("geometry") as! NSArray
            
            let latitudes = locations.valueForKey("location")?.valueForKey("lat") as! NSArray
            
            let longitudes = locations.valueForKey("location")?.valueForKey("lng") as! NSArray
            
            for var i = 0; i < addresses.count; i++ {
                var place = Place(latitude: latitudes[i] as! Double, longitude: longitudes[i] as! Double, address: addresses[i] as! String)
                
                self.places.append(place)
                
            }
            
            
        } else {
            //ocorreu algum erro na pesquisa
        }
        
        completeBlock()
    }
    
}
