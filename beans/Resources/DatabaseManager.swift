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
}
