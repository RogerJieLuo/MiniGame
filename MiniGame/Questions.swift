//
//  Questions.swift
//  MiniGame
//
//  Created by Elaine Jin on 2016-04-02.
//  Copyright © 2016 Elaine Jin. All rights reserved.
//

import UIKit


class Questions: NSObject, NSCoding {

    // MARK: Properties
    var questionLibrary: [String]
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("questions")
    
    // MARK: Types
    
    struct PropertyKey {
        static let questionsKey = "questions"
    }
    
    init?(questionLibrary: [String]) {
        self.questionLibrary = questionLibrary
        
        super.init()
        
        if questionLibrary.count == 0 {
            return nil
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(questionLibrary, forKey: PropertyKey.questionsKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let questions = aDecoder.decodeObjectForKey(PropertyKey.questionsKey) as! [String]
        
        
        // Must call designated initializer.
        self.init(questionLibrary: questions)
    }

    
    
}