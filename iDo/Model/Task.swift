
//
//  Task.swift
//  iDo
//
//  Created by Beatriz Novais on 29/05/20.
//  Copyright © 2020 Beatriz Novais. All rights reserved.
//

import Foundation

class Task: NSObject, NSCoding {
    
    var nameOfTask: String?
    var isDone: Bool?
    
    private let nameOfTaskKey = "nameOfTask"
    private let isDoneKey = "isDone"
    
    init (nameOfTask: String, isDone: Bool = false) {
        self.nameOfTask = nameOfTask
        self.isDone = isDone
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nameOfTask, forKey: nameOfTaskKey)
        aCoder.encode(isDone, forKey: isDoneKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let nameOfTask = aDecoder.decodeObject(forKey: nameOfTaskKey) as? String,
              let isDone = aDecoder.decodeObject(forKey: isDoneKey) as? Bool
            else { return }
        
        self.nameOfTask = nameOfTask
        self.isDone = isDone
    }
    
}
