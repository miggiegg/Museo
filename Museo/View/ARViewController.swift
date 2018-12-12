//
//  ARViewController.swift
//  Museo
//
//  Created by Miguel Garcia on 12/10/18.
//  Copyright © 2018 Miguel Garcia Gonzalez. All rights reserved.
//

import UIKit
import AVFoundation
import SafariServices

class ARViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var button: UIButton!
    
    var player: AVPlayer?
    @IBOutlet weak var videoView: UIView!
    
    private var urlString:String = "https://miggiegg.github.io/ARQL/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackgoundVideo()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        let safari = SFSafariViewController(url: URL(string: self.urlString)!)
        safari.delegate = self
        safari.preferredControlTintColor = UIColor.lightGray
        safari.preferredBarTintColor = UIColor.black
        self.present(safari, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    private func playBackgoundVideo() {
        if let filePath = Bundle.main.path(forResource: "background", ofType:"mp4") {
            let filePathUrl = NSURL.fileURL(withPath: filePath)
            player = AVPlayer(url: filePathUrl)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.videoView.bounds
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: nil) { (_) in
                self.player?.seek(to: CMTime.zero)
                self.player?.play()
            }
            self.videoView.layer.addSublayer(playerLayer)
            player?.play()
        }
    }
    
}
