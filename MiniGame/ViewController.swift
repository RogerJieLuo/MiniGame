//
//  ViewController.swift
//  MiniGame
//
//  Created by Elaine Jin on 2016-04-01.
//  Copyright © 2016 Elaine Jin. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    let manager = CMMotionManager()
    var status = 0   // 0: pass, 1: update question, 2: correct
    // 
    //var questions = [String]()
    //var questions: Array<String> = ["As","Bs","Cs","Ds","Es","F","G","H","I","J","As","Bs","Cs","Ds","Es","Fs","Gs","Hs","Is","Js","As","Bs","Cs","Ds","Es","Fs","Gs","Hs","Is","Js"]
    //var questions: [String]!
    var questions: Array<String>!
    var questionIndex = 0
    var tempQ = ""
    
    var knownAnswer = [Int]()
    
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
                    
                    //print"\(data!.attitude.pitch) -- \(data!.attitude.yaw) --\(data!.attitude.roll)"
                    
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
            
            
            /*
            // open device listening
            UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedRotation",
                name: UIDeviceOrientationDidChangeNotification, object: nil)
            */

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
// game process
    func setupGame() {
        /*
        knownAnswer = []
        for p in knownAnswer {
            print("\(p)")
        }
        */
        second = timeCountDown
        lbTime.text = "Time: \(second) "
        correctCount = 0
        
    }
    
    func startGame() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
        updateQuestion()
    }
    
    /*
    func receivedRotation(){
        let device = UIDevice.currentDevice()
        switch device.orientation{
        case .Portrait:
            lbTest.text = "面向设备保持垂直，Home键位于下部"
        case .PortraitUpsideDown:
            lbTest.text = "面向设备保持垂直，Home键位于上部"
        case .LandscapeLeft:
            lbTest.text = "面向设备保持水平，Home键位于左侧"
        case .LandscapeRight:
            lbTest.text = "面向设备保持水平，Home键位于右侧"
        case .FaceUp:
            answer("pass")
        case .FaceDown:
            answer("correct")
        default:
            break
        }
    }
 */
    
    func subtractTime() {
        second -= 1
        lbTime.text = "Time: \(second)"
        
        if second == 0 {
            stopGame()
            questions.append(tempQ)
            self.performSegueWithIdentifier("unwindToMenu", sender: self)
        }
    }
    
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
        //questionIndex++
        //updateQuestion()
    }
    
    func updateQuestion() {
        if questionIndex < questions.count {
            /*
            //temp fix for empty value
            while questions[questionIndex] == "" {
                print("question is empty")
                questionIndex++
            }

            lbQuestion.text = questions[questionIndex]
            */
            tempQ = questions.removeFirst()
            lbQuestion.text = tempQ
            
        }else{
            lbQuestion.text = "Sorry, there is no more question"
            stopGame()
        }
    }
    
    // if the question is known, move it out from questions list.
    func addToCorrectAnswer(){
        knownAnswer.append(questionIndex)
        //questions[questionIndex] = "known"
    }
}

