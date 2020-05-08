//
//  CachedImageLoader.swift
//  SongSearchOnSwift
//
//  Created by user on 08.05.2020.
//  Copyright © 2020 imaier. All rights reserved.
//

import Foundation
import UIKit

class CachedImageLoader {
    static let shared = CachedImageLoader()
    
    func loadImage(url:String, comletition:@escaping (_ url:String,_ image:UIImage?)-> ()) {
        if let img = self.cache[url] {
            comletition(url, img);
        } else {
            if let imgUrl = URL(string: url) {
                let task = URLSession.shared.dataTask(with: imgUrl )  { (data :Data?, response: URLResponse?, error: Error?) in
                    if let data = data {
                        let img = UIImage.init(data: data)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
                            self.cache[url] = img
                            comletition(url, img);
                        })
                    } else {
                        DispatchQueue.main.async {
                            comletition(url, nil)
                        }
                    }
                }
                task.resume()
            } else {
                comletition(url, nil)
            }
        }
    }

    var cache: Dictionary<String,UIImage> = [:]
}
