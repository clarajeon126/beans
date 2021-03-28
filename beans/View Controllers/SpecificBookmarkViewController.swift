//
//  SpecificBookmarkViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/27/21.
//

import UIKit

class SpecificBookmarkViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    
    var numInArray: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var bookmarkArray = returnDefaultBookMarkArray()
        
        
        //set the view controller as whatever value
        let bookmarkInQuestion = bookmarkArray[numInArray ?? 0]
        
        backgroundView.backgroundColor = beanColorArray[bookmarkInQuestion.bean]
        
        titleLabel.text = bookmarkInQuestion.title
        infoLabel.text = bookmarkInQuestion.info
        dateLabel.text = bookmarkInQuestion.date
        //imageView.image = bookmarkInQuestion.image
        
    }
    
    func returnDefaultBookMarkArray() -> [BookmarkData] {
        let titleArray = UserDefaults.standard.stringArray(forKey: "titleArray")
        let beanArray = UserDefaults.standard.array(forKey: "beanArray") as! [Int]
        let infoArray = UserDefaults.standard.stringArray(forKey: "infoArray")
        let dateArray = UserDefaults.standard.stringArray(forKey: "dateArray")
        //let imageArray = UserDefaults.standard.array(forKey: "imageArray") as! [UIImage]
        
        var bookmarkArray: [BookmarkData] = []
        for x in 0..<titleArray!.count {
            let title1 = titleArray![x]
            let bean1 = beanArray[x]
            let info1 = infoArray![x]
            let date1 = dateArray![x]
            //let image1 = imageArray[x]
            
            let bookmark = BookmarkData(bean: bean1, title: title1, info: info1, date: date1)
            
            bookmarkArray.append(bookmark)
        }
        return bookmarkArray
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
