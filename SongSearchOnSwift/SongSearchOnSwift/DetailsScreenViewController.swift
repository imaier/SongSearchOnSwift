//
//  DetailsScreenViewController.swift
//  SongSearchOnSwift
//
//  Created by user on 10.05.2020.
//  Copyright © 2020 imaier. All rights reserved.
//

import UIKit
import AVFoundation

class DetailsScreenViewController: UIViewController {
    var song: SongEntity? = nil
    var soundPlayer: AVAudioPlayer?
    var timer : Timer? = nil
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var albumImg: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if let song = self.song {
            self.artistLabel.text = song.artist
            self.collectionLabel.text = song.album
            self.trackLabel.text = song.track

            CachedDataLoader.shared.loadImage(url: song.albomUrl) { (url:String, image: UIImage?) in
                if url == song.albomUrl {
                    if let img = image {
                        self.albumImg.image = img
                    }
                    //songCell.activityIndicator.stopAnimating();
                }
            }

            dateFormatter.locale = Locale.current;
            dateFormatter.dateFormat = "mm:ss"
            self.currentTimeLabel.text = ""
            self.durationTimeLabel.text = ""
            //self.playButton.titleLabel?.text = "Loading..."
            self.playButton.setTitle("Loading...", for: UIControl.State.normal)
            CachedDataLoader.shared.loadData(url: song.previewUrl) { (url:String, data: Data?) in
                if url == song.previewUrl && data != nil {
                    do {
                        self.soundPlayer = try AVAudioPlayer(data: data!)
                        self.soundPlayer?.prepareToPlay()
                        
                        
                        //self.currentTimeLabel.text = self.soundPlayer?.currentTime.description
                        self.currentTimeLabel.text = self.dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: self.soundPlayer!.currentTime))
                        //self.durationTimeLabel.text = self.soundPlayer?.duration.description
                        self.durationTimeLabel.text = self.dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: self.soundPlayer!.duration))
                        
                        //self.playButton.titleLabel?.text = "Play"
                        self.playButton.setTitle("Play", for: UIControl.State.normal)
                        self.progressSlider.maximumValue = Float(self.soundPlayer!.duration)
                        self.progressSlider.minimumValue = 0;
                        self.progressSlider.value = Float(self.soundPlayer!.currentTime)
                    } catch {
                        // couldn't load file :(
                    }
                }
            }
        }
        
    }
    
    @IBAction func play(_ sender: UIButton) {
        if let sp = self.soundPlayer {
            if sp.isPlaying {
                sp.pause()
                self.playButton.setTitle("Play", for: UIControl.State.normal)
                self.timer?.invalidate()
                self.timer = nil
            } else {
                sp.play()
                self.playButton.setTitle("Pause", for: UIControl.State.normal)
                
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (_:Timer) in
                    self.currentTimeLabel.text = self.dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: self.soundPlayer!.currentTime))
                    self.progressSlider.value = Float(self.soundPlayer!.currentTime)
                })
                //self.timer?.fire()
            }
        }
    }
}
