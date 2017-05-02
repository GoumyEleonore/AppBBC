//
//  bbcApi.swift
//  AppEG
//
//  Created by Eléonore Goumy on 21/04/2017.
//  Copyright © 2017 Eléonore Goumy. All rights reserved.
//

import UIKit
import Alamofire


class bbcApi: NSObject {
    static func getBBCSportsArticles( completion:  @escaping (_ result: NSDictionary) -> Void) {
        print("Launching request getBBC...")
        
        let parameters : Parameters = ["apiKey" : "b9d169a63696498396de01652dcaaa51",
                                       "source" : "bbc-sport" ]

        Alamofire.request("https://newsapi.org/v1/articles?", method: .get, parameters: parameters).responseJSON { (response) in
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                completion(JSON)
        
            }
            
        }
    }
    
    static func countNbArticle(listOfArticles: [NSDictionary]) -> Int {
        return 0
    }
    
    static func downloadImage(url: String, completion:  @escaping (_ result: UIImage) -> Void) {
        let catPictureURL = URL(string: url)!
        
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        completion(image!)
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
    }
}
