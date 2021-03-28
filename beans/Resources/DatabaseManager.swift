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
    
    
    //get homebean data from firebase
    public func homebeanArrayFromFirebase(completion: @escaping (_ homebean: [ItemInfo])->()){
        let homebeanDatabase = database.child("housebean")
        
        homebeanDatabase.observeSingleEvent(of: .value) { (snapshot) in
            var itemInfoArray = [ItemInfo]()
            var numOfChildThroughFor = 0
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    if let data = childSnapshot.value as? [String: Any]{
                        ItemInfo.parse(data: data) { (itemInfo) in
                            numOfChildThroughFor += 1
                            itemInfoArray.append(itemInfo)
                            if numOfChildThroughFor == snapshot.childrenCount {
                                return completion(itemInfoArray)
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func chembeanArrayFromFirebase(completion: @escaping (_ chembean: [ItemInfo])->()){
        let chembeanDatabase = database.child("chembean")
        
        chembeanDatabase.observeSingleEvent(of: .value) { (snapshot) in
            var itemInfoArray = [ItemInfo]()
            var numOfChildThroughFor = 0
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    if let data = childSnapshot.value as? [String: Any]{
                        ItemInfo.parse(data: data) { (itemInfo) in
                            numOfChildThroughFor += 1
                            itemInfoArray.append(itemInfo)
                            if numOfChildThroughFor == snapshot.childrenCount {
                                return completion(itemInfoArray)
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func itemhistobeanArrayFromFirebase(completion: @escaping (_ itemhistobean: [ItemInfo])->()){
        let itemhistobeanDatabase = database.child("itemhistobean")
        
        itemhistobeanDatabase.observeSingleEvent(of: .value) { (snapshot) in
            var itemInfoArray = [ItemInfo]()
            var numOfChildThroughFor = 0
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    if let data = childSnapshot.value as? [String: Any]{
                        ItemInfo.parse(data: data) { (itemInfo) in
                            numOfChildThroughFor += 1
                            itemInfoArray.append(itemInfo)
                            if numOfChildThroughFor == snapshot.childrenCount {
                                return completion(itemInfoArray)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
}
