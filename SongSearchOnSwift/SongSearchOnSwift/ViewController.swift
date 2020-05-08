//
//  ViewController.swift
//  SongSearchOnSwift
//
//  Created by Ilya Maier on 05.05.2020.
//  Copyright © 2020 imaier. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    var ladedData = [SongEntity]();
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 5 {
            self.search(withText: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            self.search(withText: text)
        }
    }
    
    func search(withText text:String) -> Void {
        let urlOpt = URL(string: "https://itunes.apple.com/search?term=\(text)")
        if let url = urlOpt {
            let task = URLSession.shared.dataTask(with: url ) { (data :Data?, response: URLResponse?, error: Error?) in
                if let data = data {
                    let searchResults: NSDictionary = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    
                    let results = searchResults.value(forKey: "results") as! NSArray
                    //let results: NSDictionary = searchResults["results"]
                    var list = Array<SongEntity>();
                    
                    for (_, result) in results.enumerated() {
                        let dict = result as! Dictionary<String, Any>
                        list.append(SongEntity(with: dict))
                    }
                    
                    DispatchQueue.main.async {
                        self.ladedData = list
                        self.tableView.reloadData();
                    }
                }
            }
            task.resume();
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ladedData.count
    }
    
    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        
        let songData = self.ladedData[indexPath.row]

        if let songCell = cell as? SongCell {
            
            songCell.song = songData
            songCell.artist?.text = songData.artist
            songCell.track?.text = songData.track
            songCell.albumImage.image = nil
            songCell.activityIndicator.startAnimating()
            songCell.activityIndicator.isHidden = false
            //songCell.backgroundColor = UIColor.gray
            
            CachedImageLoader.shared.loadImage(url: songData.albomUrl) { (url:String, image: UIImage?) in
                if url == songCell.song?.albomUrl {
                    if let img = image {
                        songCell.albumImage.image = img
                    }
                    songCell.activityIndicator.stopAnimating();
                }
            }
        }
        
        return cell
    }
}

