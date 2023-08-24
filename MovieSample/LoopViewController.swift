//
//  LoopViewController.swift
//  MovieSample
//
//  Created by sako0602 on 2023/08/02.
//

import UIKit
import AVFoundation

class LoopViewController: UIViewController {
    
    private var player = AVPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
        self.player.play()
        
    }
    private func playVideo(){
        guard let path = Bundle.main.path(forResource: "water", ofType: "MOV") else { fatalError("nilっす")}
        player = AVPlayer(url: URL(filePath: path))
        let playerLayout = AVPlayerLayer(player: player)
        playerLayout.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        playerLayout.videoGravity = .resizeAspect//🍔書き換え
        playerLayout.repeatCount = 0//🍔永遠に繰り返される方法があるらしいい。Opt＋クリック
        playerLayout.anchorPointZ = -1
        view.layer.insertSublayer(playerLayout, at: 0)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            self.player.seek(to: .zero)
            self.player.play()
        }
    }
}
