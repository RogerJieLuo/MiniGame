//
//  GWViewController.swift
//  MiniGame
//
//  Created by Elaine Jin on 2016-04-01.
//  Copyright © 2016 Elaine Jin. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox

enum gameStatus {
    case menu
    case tutorial
    case pass
    case correct
    case show
    case drop
    case score
    case end
}

enum questionArea {
    case people
    case phase
    case brand
}

class GWViewController: UIViewController {

    var simMode = true
    let manager = CMMotionManager()
    
    var status = 0   // 3: pass, 1: update question, 2: correct
    //var questions: Array<String>!
    var questions = Array<String>()
    var questionIndex = 0
    var tempQ = ""
    var score = 0
    var correctCount: Int = 0
    
    var timer = NSTimer()
    var second = 0
    var timeCountDown = 5
    
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbTest: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background_1.jpg")!)
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        setupGame()
        lbTest.text = "\(questions)"
        if questions.count == 0{
            print("no item")
        }else{
            
            startGame()
            
            manager.gyroUpdateInterval = 0.1
            manager.startGyroUpdates()
            var currentRoll = 0.0
            if manager.deviceMotionAvailable {
                manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
                    [weak self] (data: CMDeviceMotion?, error: NSError?) in
                    if self != nil {
                    currentRoll = data!.attitude.roll
                    if currentRoll > -1.8  && currentRoll < -1.0 {
                        // when the device was "stand up vertically and in landscape mode"
                        if self!.status != 1 {
                            self!.updateQuestion()
                            self!.status = 1
                        }
                    }else if currentRoll > -1.0 {
                        // when device roll forward a little bit
                        if self!.status != 3 {
                            self!.answer("pass")
                            self!.lbQuestion.text = "PASS"
                            self!.status = 3
                        }
                    }else {
                        // when device roll back a little bit
                        if self!.status != 2 {
                            self!.answer("correct")
                            self!.lbQuestion.text = "CORRECT"
                            self!.status = 2
                        }
                    }
                    
                    if self!.questions.count == 0 {
                        self!.manager.stopGyroUpdates()
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
    
    
//MARK: Game process
    func setupGame() {
        second = timeCountDown
        lbTime.text = "Time: \(second) "
        correctCount = 0
    
        loadQuestionToGame()
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
            print("correctCount \(correctCount)")
            self.performSegueWithIdentifier("unwindToMenu", sender: self)
        }
    }
    
    // stop game
    func stopGame() {
        timer.invalidate()
        //manager.stopGyroUpdates()
        print("stop game")
        
        if questions.count != 0 {
            tempQ = questions.removeFirst()
            questions.append(tempQ)
            //questions.append(tempQ)
        }
        saveQuestion()  // stores questions to permanent data
    }
    
    @IBAction func correctQ(sender: UIButton) {
        answer("correct")
        updateQuestion()
    }
    
    @IBAction func passQ(sender: UIButton) {
        answer("pass")
        updateQuestion()
    }
    
    func answer(answerType: String) {
        if questions.count > 0 {
            if answerType == "correct" {
                correctCount += 1
                
                lbQuestion.text = "CORRECT"
                questions.removeFirst()
                // Load "coin.wav"
                if let soundURL = NSBundle.mainBundle().URLForResource("coin", withExtension: "wav") {
                    var mySound: SystemSoundID = 0
                    AudioServicesCreateSystemSoundID(soundURL, &mySound)
                    // Play
                    AudioServicesPlaySystemSound(mySound);
                }
            } else if answerType == "pass" {
                tempQ = questions.removeFirst()
                questions.append(tempQ)
                lbQuestion.text = "PASS"
                // Load "pop.wav"
                if let soundURL = NSBundle.mainBundle().URLForResource("pop", withExtension: "wav") {
                    var mySound: SystemSoundID = 0
                    AudioServicesCreateSystemSoundID(soundURL, &mySound)
                    // Play
                    AudioServicesPlaySystemSound(mySound);
                }
            } else {
                
            }
        }
    }
    
    func updateQuestion() {
        if questionIndex < questions.count {
            lbQuestion.text = questions.first
        }else{
            lbQuestion.text = "Sorry, there is no more question"
            stopGame()
        }
    }
    
// MARK: manipulate question library
    func loadQuestionToGame() {
        // load questions
        // if there are stored questions, use stored questions
        // if not, reload the questions file
        if let savedQuestion = loadQuestion()  {
            if savedQuestion.count > 0 {
                questions = savedQuestion
            }else{
                loadQuestionLibrary()
            }
        }else{
            loadQuestionLibrary()
        }
        
    }
    
    func loadQuestionLibrary(){
        let path = NSBundle.mainBundle().pathForResource("Word_test", ofType: "txt")
        var contents: String
        
        do {
            contents = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            questions = contents.characters.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
        }catch{
            contents = "error"
        }
        
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "unwindToMenu") {
            print("unwind")
            //get a reference to the destination view controller
            let destinationVC: MenuViewController = segue.destinationViewController as! MenuViewController
            print("correct num is: \(correctCount)")
            //set properties on the destination view controller
            destinationVC.score = correctCount
            //etc...
        }

    }

    
// MARK: NSCoding -- persistent data
    func saveQuestion() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(questions, toFile: Questions.ArchiveURL.path!)
        //let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(questions, toFile: "questionLibrary/questionsLibrary")
        if !isSuccessfulSave {
            print("Failed to save question...")
        }
    }
    
    // get the data from file
    func loadQuestion() -> Array<String>? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Questions.ArchiveURL.path!) as? Array<String>
        //return NSKeyedUnarchiver.unarchiveObjectWithFile("questionLibrary/questionsLibrary") as? [String]
    }
    


}

