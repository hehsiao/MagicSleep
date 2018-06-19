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
    var counter = 30.0
    var timer = Timer()
    var isPlaying = false
    var player: AVAudioPlayer?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var playerProgress: UIProgressView!
    @IBOutlet weak var playerSlider: UISlider!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.text = timeString(time: TimeInterval(counter))
        pauseButton.isEnabled = false
        
        playerProgress.progress = 0.0
        playerSlider.isContinuous = false
        
        timePicker.countDownDuration = TimeInterval(3600)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickTime(_ sender: Any) {
        timeLabel.text = timeString(time: TimeInterval(counter))
    }
    
    @IBAction func adjustSlider(_ playerSlider: UISlider) {
        if player != nil {
            player!.currentTime = TimeInterval(playerSlider.value)
        }
    }
    
    @IBAction func startTimer(_ sender: Any) {
        if isPlaying {
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
        counter = 360.0
        playerProgress.progress = 0.0
        progressLabel.text = timeString(time: TimeInterval(playerProgress.progress))
        timeLabel.text = timeString(time: TimeInterval(counter))
    }
    
    func updateTimer() {
        // increase progress value
        
        if counter < 1 {
            timer.invalidate()
            player!.stop()
            //Send alert to indicate "time's up!"
        } else {
            counter -= 1
            if (player!.currentTime >= player!.duration - 2) {
                player!.currentTime = TimeInterval(124.0)
            }
            
            playerProgress.progress = Float(player!.currentTime / player!.duration)
            playerSlider.value = Float(player!.currentTime)
            progressLabel.text = timeString(time: TimeInterval(player!.currentTime))
            timeLabel.text = timeString(time: TimeInterval(counter))
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    
    func playSound() {
        if playerProgress.progress >= 1  {
            playerProgress.progress = 0.0
        }
        
        if player == nil {
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
        
        playerSlider.maximumValue = Float(player!.duration)
    }
    
    func stopSound() {
        if player != nil && player!.isPlaying {
            player!.stop()
        }
    }
    

}

