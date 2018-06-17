//
//  ViewController.swift
//  MagicSleep
//
//  Created by Henry Hsiao on 2018-06-15.
//  Copyright © 2018 Henry Hsiao. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var counter = 60.0
    var timer = Timer()
    var isPlaying = false
    var player: AVAudioPlayer?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startTimer(_ sender: Any) {
        if(isPlaying) {
            return
        }
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        
        playSound()
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { _ in self.updateTimer() }
        )
        
        isPlaying = true
    }
    
    @IBAction func pauseTimer(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        
        timer.invalidate()
        stopSound()
        isPlaying = false
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        
        timer.invalidate()
        stopSound()
        isPlaying = false
        counter = 60.0
        timeLabel.text = timeString(time: TimeInterval(counter))
    }
    
    func updateTimer() {
        if counter < 1 {
            timer.invalidate()
            //Send alert to indicate "time's up!"
        } else {
            counter -= 1
            timeLabel.text = timeString(time: TimeInterval(counter))
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.text = String(counter)
        pauseButton.isEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func playSound() {
        if (player == nil) {
            if let sound = NSDataAsset(name: "travelsleep_full") {
                do {
                    try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try! AVAudioSession.sharedInstance().setActive(true)
                    try player = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileType.mp3.rawValue)
                    player!.play()
                } catch {
                    print("error initializing AVAudioPlayer")
                }
            }
        } else {
            player!.play()
        }
    }
    
    func stopSound() {
        if (player!.isPlaying) {
            player!.stop()
        }
    }

}

