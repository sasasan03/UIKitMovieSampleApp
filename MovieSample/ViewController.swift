//
//  ViewController.swift
//  MovieSample
//
//  Created by sako0602 on 2023/08/01.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var videoPlayer: AVPlayer!
    lazy var seekBar = UISlider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - AVPlayerItemを作成
        guard let path = Bundle.main.path(forResource: "sky", ofType: "mp4") else { fatalError("🍔：Movie file can not find") }
        let fileURL = URL(filePath: path)
        let avAsset = AVURLAsset(url: fileURL)
        let playerItem: AVPlayerItem = AVPlayerItem(asset: avAsset)
        
        //MARK: - AVPlayerを作成
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        //MARK: - AVPlayreを追加
        let layer = AVPlayerLayer()
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        layer.player = videoPlayer

        layer.frame = view.bounds
        view.layer.addSublayer(layer)
        
        //MARK: - スライダーを作成
        seekBar.frame = CGRect(x: 0, y: 0, width: view.bounds.minX - 200, height: 50)
        seekBar.layer.position = CGPoint(x: view.bounds.midX, y: view.bounds.maxY - 100)
        seekBar.minimumValue = 0
        seekBar.maximumValue = Float(CMTimeGetSeconds(avAsset.duration))
        seekBar.addTarget(self, action: #selector(onSliderValueChange), for: UIControl.Event.touchUpInside)
        view.addSubview(seekBar)
        
        //MARK: - 「ムービー」と「バー」を同期させる
        let interval: Double = Double(0.5 * seekBar.maximumValue) / Double(seekBar.bounds.maxX)
        
        let time: CMTime = CMTimeMakeWithSeconds(interval, preferredTimescale: Int32(NSEC_PER_SEC))
        
        videoPlayer.addPeriodicTimeObserver(forInterval: time, queue: nil) { time in
            let duration = CMTimeGetSeconds(self.videoPlayer.currentItem!.duration)
            let time = CMTimeGetSeconds(self.videoPlayer.currentTime())
            let value = Float(self.seekBar.maximumValue - self.seekBar.minimumValue) * Float(time) / Float(duration) + Float(self.seekBar.minimumValue)
            self.seekBar.value = value
        }
        
        //MARK: - ボタンを作成
        let startButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let buttonHeight: CGFloat = 10
        let buttonPadding = 50.0
        startButton.layer.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.height - 40)// - (buttonHeight / 2 + buttonPadding))
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 20.0
        startButton.backgroundColor = UIColor.orange
        startButton.setTitle("再生", for: UIControl.State.normal)
        startButton.addTarget(self, action: #selector(startMovie), for: UIControl.Event.touchUpInside)
        view.addSubview(startButton)
    }
    
    //MARK: - メソッド
    @objc func startMovie(){
        videoPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)))
        videoPlayer.play()
    }
    
    @objc func onSliderValueChange(){
        videoPlayer.seek(to: CMTimeMakeWithSeconds(Float64(seekBar.value), preferredTimescale: Int32(NSEC_PER_SEC)))
    }


}

