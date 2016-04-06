//
//  MenuViewController.swift
//  MiniGame
//
//  Created by Elaine Jin on 2016-04-01.
//  Copyright © 2016 Elaine Jin. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var score = 0
    
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbTest: UILabel!
    @IBOutlet weak var tfTest: UITextField!
    
    //var questions = [String]()
    var questions = Array<String>()
    //var questionLibrary = Questions
    var knownQuestion = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background_1.jpg")!)
        
        if let savedQuestion = loadQuestion()  {
            if savedQuestion.count > 0 {
                //print(savedQuestion)
                questions = savedQuestion
            }else{
                loadQuestionLibrary()
            }
        }else{
            // First time open the game, Load the sample data.
            loadQuestionLibrary()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: manipulate question library
    
    func loadQuestionLibrary(){
        let path = NSBundle.mainBundle().pathForResource("questions", ofType: "txt")
        var contents: String
        
        do {
            contents = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            questions = contents.characters.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
        }catch{
            contents = "error"
        }
        
    }
    
    // there should be a better way to faster it
    // or directly delete the words from file
    func updateQuestionLibrary(var i: Int){
        
        // delete the words already be known
        while(i<questions.count){
            if questions[i] == "" {
                questions.removeAtIndex(i)
                updateQuestionLibrary(i)
            }else{
                i += 1
            }
        }

        saveQuestion()
        
    }
    
    @IBAction func unwindToMenuList(sender: UIStoryboardSegue) {
        let sourceViewController = sender.sourceViewController as? ViewController
        score = sourceViewController!.correctCount
        lbScore.text = "Score: \(score)"
        /*
        let arr = sourceViewController!.knownAnswer
        for q in arr {
            //lbTest.text = lbTest.text! + " \(q)"
            print("a \(q) -- \(questions.count)")
            questions[q] = ""
        }
        */
        questions = sourceViewController!.questions
        //updateQuestionLibrary(0)
        saveQuestion()
    }

    
    // MARK: - Navigation

    @IBAction func backToList(sender: UIButton) {
        //self.performSegueWithIdentifier("unwindToList", sender: self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playGame" {
            let game: ViewController = segue.destinationViewController as! ViewController
            game.questions = self.questions
        }
    }
    
    // MARK: NSCoding
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
