//
//  ViewController.swift
//  MiniGame
//
//  Created by Elaine Jin on 2016-04-01.
//  Copyright © 2016 Elaine Jin. All rights reserved.
//

import UIKit
import CoreMotion

enum gameStatus {
    case menu
    case tutorial
    case game
    case drop
    case showScore
    case end
}

class ViewController: UIViewController {

    let manager = CMMotionManager()
    
    var status = 0   // 0: pass, 1: update question, 2: correct
    var questions: Array<String>!
    var questionIndex = 0
    var tempQ = ""
    var correctCount = 0
    
    var timer = NSTimer()
    var second = 0
    var timeCountDown = 90
    
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    @IBOutlet weak var lbTest: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background_1.jpg")!)
        
        if questions == nil {
            print("no item")
        }else{
            manager.gyroUpdateInterval = 0.1
            manager.startGyroUpdates()
            
            setupGame()
            startGame()
            
            var currentRoll = 0.0
            if manager.deviceMotionAvailable {
                manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
                    [weak self] (data: CMDeviceMotion?, error: NSError?) in
                    
                    
                    currentRoll = data!.attitude.roll
                    if currentRoll > -1.8  && currentRoll < -1.0 {
                        if self!.status != 1 {
                            self!.updateQuestion()
                            self!.status = 1
                        }
                    }else if currentRoll > -1.0 {
                        if self!.status != 0 {
                            self!.answer("pass")
                            self!.lbQuestion.text = "PASS"
                            self!.status = 0
                        }
                    }else {
                        if self!.status != 2 {
                            self!.answer("correct")
                            self!.lbQuestion.text = "CORRECT"
                            self!.status = 2
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
// game process
    func setupGame() {
        second = timeCountDown
        lbTime.text = "Time: \(second) "
        correctCount = 0
    }
    
    // start game and time countdown
    func startGame() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
        updateQuestion()
    }
    
    func subtractTime() {
        second -= 1
        lbTime.text = "Time: \(second)"
        
        if second == 0 {
            stopGame()
            questions.append(tempQ)
            self.performSegueWithIdentifier("unwindToMenu", sender: self)
        }
    }
    
    // stop game
    func stopGame() {
        timer.invalidate()
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
        
    }
    
    func answer(answerType: String) {
        if questions.count > 0 {
        if answerType == "correct" {
            correctCount += 1
            //addToCorrectAnswer()
        } else if answerType == "pass" {
          questions.append(tempQ)
        } else {
            
        }
        }
    }
    
    func updateQuestion() {
        if questionIndex < questions.count {
            tempQ = questions.removeFirst()
            lbQuestion.text = tempQ
            
        }else{
            lbQuestion.text = "Sorry, there is no more question"
            stopGame()
        }
    }

}

