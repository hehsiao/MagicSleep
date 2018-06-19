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
    var timer = Timer()
    var isPlaying = false
    var player: AVAudioPlayer?
    var count = 0
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 50.0, weight: UIFont.Weight.light)
        pauseButton.isEnabled = false
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    @IBAction func pickTime(_ sender: Any) {
        count = Int(timePicker.countDownDuration)
        print(count)
        timeLabel.text = timeString(time: timePicker.countDownDuration)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startTimer(_ sender: Any) {
        if isPlaying {
            return
        }
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        timePicker.isHidden = true
        timePicker.isEnabled = false
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
        timePicker.isHidden = false
        timePicker.isEnabled = true
        timer.invalidate()
        stopSound()
        isPlaying = false
    }
    
    func updateTimer() {
        if count < 1 {
            timer.invalidate()
            player!.stop()
        } else {
            count -= 1
            if (player!.currentTime >= player!.duration - 2) {
                player!.currentTime = TimeInterval(124.0)
            }
            timeLabel.text = timeString(time: TimeInterval(count))
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    
    func playSound() {
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
    }
    
    func stopSound() {
        if player != nil && player!.isPlaying {
            player!.stop()
        }
    }
    

}

