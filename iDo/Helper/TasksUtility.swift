//
//  TasksUtility.swift
//  iDo
//
//  Created by Beatriz Novais on 01/06/20.
//  Copyright © 2020 Beatriz Novais. All rights reserved.
//

import Foundation

class TasksUtility {
    
    private static let key = "tasks"
    
    // User Default Date storage
    
    // archive
    
    private static func archive(_ tasks: [[Task]]) -> NSData {
        return NSKeyedArchiver.archivedData(withRootObject: tasks) as NSData
        
    }
    
    // fetch
    
    static func fetch() -> [[Task]]? {
        guard let unarchivedData = UserDefaults.standard.object(forKey: key) as? Data else {return nil}
        
        //unarchive Data
        return NSKeyedUnarchiver.unarchiveObject(with: unarchivedData) as? [[Task]]
    }
        // save
    
    static func save(_ tasks: [[Task]]) {
        //archive
        let archivedTasks = archive(tasks)
        
        //set object for key
        UserDefaults.standard.set(archivedTasks, forKey: key)
        UserDefaults.standard.synchronize() //write data to disk imediatamente
    }
    
}
