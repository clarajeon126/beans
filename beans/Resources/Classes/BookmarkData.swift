//
//  BookmarkData.swift
//  beans
//
//  Created by Clara Jeon on 3/27/21.
//

import Foundation
import UIKit

public class BookmarkData {
    var bean: Int
    var title: String
    var info: String
    var date: String
    var image: UIImage
    
    init(bean: Int, title: String, info: String){
        self.bean = bean
        self.title = title
        self.info = info
        
        //get formatted date
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMMM d yyyy"
        let formattedDate = dateFormatter.string(from: date)
        self.date = formattedDate.lowercased()
        
        self.image = #imageLiteral(resourceName: "item histo bean")
    }
    
    init(bean: Int, title: String, info: String, date: String, image: UIImage){
        self.bean = bean
        self.title = title
        self.info = info
        self.date = date
        self.image = image
    }
}
