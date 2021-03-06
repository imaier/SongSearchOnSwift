//
//  SongCell.swift
//  SongSearchOnSwift
//
//  Created by Ilya Maier on 06.05.2020.
//  Copyright © 2020 imaier. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {
    var song: SongEntity? = nil
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var track: UILabel!
}
