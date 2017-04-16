//
//  Utils.swift
//  ClubAnimal
//
//  Created by HenrySu on 4/13/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static func loadImageFromURL(imageView: UIImageView, urlString: String) {
        let imgURL: URL = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: imgURL) { (data, response, error) in
            
            guard let data = data, error == nil else {return}
            
            DispatchQueue.main.async(execute: {
                imageView.image = UIImage(data: data)
            })
            }.resume()
        
    }
    
    
    
    static func splitDateString(dateString: String) -> (date: String?, time: String?) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateString)!
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let date_str = dateFormatter.string(from:date)
        
        dateFormatter.dateFormat = "HH:mm"
        let time_str = dateFormatter.string(from:date)
        
        return (date_str, time_str)
        
    }
    

    
}
