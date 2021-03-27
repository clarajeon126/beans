//
//  DatabaseManager.swift
//  beans
//
//  Created by Clara Jeon on 3/27/21.
//

import Foundation
import FirebaseDatabase

public class DatabaseManager{
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    public func addRecommend(bean: String, recommend: String){
        let recommendChildRef = database.child("recommendations").childByAutoId()
        let recommendObj = ["bean type": bean, "info": recommend]
        
        recommendChildRef.setValue(recommendObj)
    }
}
