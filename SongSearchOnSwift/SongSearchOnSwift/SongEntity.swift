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
    
    init(with dict:Dictionary<String, Any>) {
        
        
        self.track = dict["trackName"] as String
        self.album = dict["collectionName"] as String
        self.artist = dict["artistName"] as String
        self.albomUrl = dict["artworkUrl100"] as String
    }
    
}
