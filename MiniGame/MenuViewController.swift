//
//  MenuViewController.swift
//  MiniGame
//
//  Created by Elaine Jin on 2016-04-01.
//  Copyright © 2016 Elaine Jin. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var score: Int!
    
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbTest: UILabel!
    @IBOutlet weak var tfTest: UITextField!
    
    //var questions = [String]()
    var questions = Array<String>()
    //var questionLibrary = Questions
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background_1.jpg")!)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: manipulate question library
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
    
    
    @IBAction func unwindToMenuList(sender: UIStoryboardSegue) {
       /*
        //if let sourceViewController = sender.sourceViewController as? GWViewController {
        let sourceViewController = sender.sourceViewController as? GWViewController
            if score == sourceViewController!.score {
                lbScore.text = "Score: \(score)"
            } else {
                lbScore.text = "No Score Return"
            }
        //}else {
            //lbScore.text = "No source"
        //}
*/
        lbScore.text = "Score: \(score)"
        
        if let sourceViewController = sender.sourceViewController as? GWViewController {
            questions = sourceViewController.questions
            sourceViewController.manager.stopDeviceMotionUpdates()
        }
        
        saveQuestion()
    }

    
    // MARK: - Navigation

    @IBAction func backToList(sender: UIButton) {
        //self.performSegueWithIdentifier("unwindToList", sender: self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playGame" {
            /*
            let game: ViewController = segue.destinationViewController as! ViewController
            game.questions = self.questions
 */
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
