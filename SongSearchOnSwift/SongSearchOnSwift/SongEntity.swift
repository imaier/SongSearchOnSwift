//
//  SongEntity.swift
//  SongSearchOnSwift
//
//  Created by Ilya Maier on 06.05.2020.
//  Copyright © 2020 imaier. All rights reserved.
//

import Foundation

struct SongEntity {
    var track = ""
    var album = ""
    var artist = ""
    var albomUrl = ""
    var previewUrl = ""
    
    
    init(with dict:Dictionary<String, Any>) {
        
        if let str = dict["trackName"] as? String {
            self.track = str
        }
        if let str = dict["collectionName"] as? String {
            self.album = str
        }
        if let str = dict["artistName"] as? String {
            self.artist = str
        }
        if let str = dict["artworkUrl100"] as? String {
            self.albomUrl = str
        }
        if let str = dict["previewUrl"] as? String {
            self.previewUrl = str
        }
    }
    
}
