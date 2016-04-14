//
//  FMTwoCollectionViewCell.swift
//  MiniGame
//
//  Created by Elaine Jin on 2016-04-09.
//  Copyright © 2016 Elaine Jin. All rights reserved.
//

import UIKit

class FMTwoCollectionViewCell: UICollectionViewCell {
    var numberOfSequence: Int = Int()
    var tapOfSequence: Int = Int()
    var tapped = false
    var showing = false
    
    @IBOutlet weak var lbNumber: UILabel!
    
    var timer = NSTimer()
    var showSecond = 1.0
    
    func flash() {
        self.backgroundColor = UIColor.greenColor()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(subtractTime), userInfo: nil, repeats: true)
        showing = true
    }
    
    func subtractTime() {
        if showSecond > 0 {
            showSecond -= 1
        }
        //print(showSecond)
        if showSecond <= 0 {
            self.backgroundColor = UIColor.whiteColor()
            //lbNumber.text = "Test"
            showing = false
            timer.invalidate()
        }
    }
    
    func checkShowing() -> Bool {
        return showing
    }
}
