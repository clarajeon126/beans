//
//  ItemInfo.swift
//  beans
//
//  Created by Clara Jeon on 3/28/21.
//

import Foundation

public class ItemInfo{
    var keyword: [String]
    var title: String
    var info: String
    
    init(keyword: [String], title: String, info: String){
        self.keyword = keyword
        self.title = title
        self.info = info
    }
    
    static func parse(data: [String: Any], completion: @escaping (_ itemInfo: ItemInfo)->()){
        if let title = data["title"] as? String,
           let info = data["info"] as? String{
            print("first if")
            if let keywords = data["keyword"] as? [String]{
            
                print("second if")
            
            let item = ItemInfo(keyword: keywords, title: title, info: info)
            
            return completion(item)
            }
        }
    }
}
