//
//  FMTwoViewController.swift
//  MiniGame
//
//  Created by Elaine Jin on 2016-04-09.
//  Copyright © 2016 Elaine Jin. All rights reserved.
//

import UIKit

enum FMTwoGameStatus {
    case idel
    case ready
    case show
    case start
    case stop
}

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

class FMTwoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //var td: [Int] = [4,3,6,7,8,9,5,12,11,15,14,0,1,2,13,10]     // the showing sequence
    var td = [Int]()
    var rowNumber: Double!     //3.0
    var colNumber: Double!   //3.0
    
    var showSequence: [Int] = [Int]()   // use td instead
    var tapSequence: [Int] = [Int]()    // show the tap sequence
    var sequence = 0        // count when tap
    
    var timer = NSTimer()
    var showSecond = 1.0    // each cell when start flash color for 1 second
    var countUp = 0.0
    var gap: Double!     // 1.0
    
    var status: FMTwoGameStatus = .start
    var gameEnd = false
    
    @IBOutlet weak var Tcollectionview: UICollectionView!
    @IBOutlet weak var tfTest: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Tcollectionview.dataSource = self
        Tcollectionview.delegate = self
        
        Tcollectionview.layer.borderWidth = 1
        Tcollectionview.layer.borderColor = UIColor.blackColor().CGColor
        
        setupGame()
        print("rownum: \(rowNumber) - colnum: \(colNumber) - gap: \(gap)")
    }
    
    func setupGame() {
        // create a array
        td = [Int]()
        for num in 0...Int(rowNumber * colNumber - 1) {
            td.append(num)
        }
        td.shuffleInPlace()
        showSequence = [Int]()
        tapSequence = [Int]()
        //rowNumber = 3.0
        //colNumber = 3.0
        sequence = 0
        //countUp = 0
        
        print("td: \(td)")
        print("showsequence: \(showSequence)")
        print("tapsequence: \(tapSequence)")
        print("row: \(rowNumber) - col: \(colNumber) - sequence: \(sequence)")
    }
    
    func newGame() {
        // setup
        // shuffle array
        setupGame()
        
        // reset all the color to white
        for num in 0 ... Int(rowNumber * colNumber - 1) {
            let cell = self.Tcollectionview.cellForItemAtIndexPath(NSIndexPath(forItem: num, inSection: 0 )) as! FMTwoCollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            cell.lbNumber.text = ""
            cell.tapped = false
            cell.numberOfSequence = Int()
            cell.tapOfSequence = Int()
            
            status = .ready
        }
    }

    func start() {
        status = .show
        countUp = 0.0
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(subtractTime), userInfo: nil, repeats: true)
    }
    
    @IBAction func startGame(sender: UIButton) {
        if !gameEnd {
            start()
        }
        //sender.titleLabel?.text = "Re play"
    }
    @IBAction func restart(sender: UIButton) {
        // refresh
        if !gameEnd {
            start()
        }
    }
    
    @IBAction func startNewGame(sender: UIButton) {
        //if gameEnd {
            newGame()
            gameEnd = false
        //}
    }
    
 
    func subtractTime() {
        if countUp < (showSecond + gap) * (rowNumber * colNumber) {
            print(countUp)
            var temp = showSecond + gap
            if countUp % temp == 0 {
                let cell = self.Tcollectionview!.cellForItemAtIndexPath(NSIndexPath(forItem: td[Int(countUp/temp)], inSection: 0)) as! FMTwoCollectionViewCell
            
                cell.numberOfSequence = Int(countUp/temp)
                cell.flash()
            }
            countUp += 1
        } else  {
            print("stop showing")
            status = .start
            timer.invalidate()
        }
    }
    

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
// load collection view
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if status == .start {
            var correct = false
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FMTwoCollectionViewCell
            
            if !cell.tapped {
                //cell.tapOfSequence == sequence
                
                if cell.numberOfSequence == sequence {
                    // tap correct cube
                    correct = true
                    cell.tapOfSequence = sequence
                    cell.tapped = true
                    cell.lbNumber.text = "\(sequence)"
                    sequence += 1
                    cell.backgroundColor = UIColor.greenColor() // doesn't work in some way

                    print("\(sequence)")
                } else {
                    cell.tapOfSequence = 0
                    cell.layer.borderColor = UIColor.redColor().CGColor
                    delay(0.5) {
                        cell.layer.borderColor = UIColor.blackColor().CGColor
                    }
                }
                
            }else {
                // if tapped == true means the cube has been tapped, no more action on the same cube
            }
            /*
            if correct {
                cell.tapOfSequence = sequence
                cell.tapped = true
                cell.lbNumber.text = "\(sequence + 1)"
                sequence += 1
                cell.backgroundColor = UIColor.greenColor() // doesn't work in some way
            } else {}
            */
            if sequence == td.count {
                // successfully go through the game
                status = .stop
                gameEnd = true
            } else {}
        }
    }
    

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FMTwoCell", forIndexPath: indexPath) as! FMTwoCollectionViewCell
        
        let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
        
        cell.layer.borderColor = bcolor.CGColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        cell.backgroundColor=UIColor.whiteColor()
        //print("here")
        return cell

    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return td.count
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = Tcollectionview.bounds.size.width / CGFloat(colNumber)
        return CGSizeMake(width - 1, width - 1)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
