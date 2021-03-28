//
//  InfoViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/28/21.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBAction func bookmarkTapped(_ sender: Any) {
        
        print("pressed bookmarks")
        var storedBookmarks = returnDefaultBookMarkArray()
        
        let newBookMark = BookmarkData(bean: beanNum!, title: titleFill!, info: infoFill!)
        storedBookmarks.append(newBookMark)
        storeBookMarkArrayToUserDefaults(bmArray: storedBookmarks)
        
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    var titleFill: String?
    var infoFill: String?
    var beanNum: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleFill
        
        infoLabel.text = infoFill
        backgroundView.backgroundColor = beanColorArray[beanNum ?? 0]
        // Do any additional setup after loading the view.
    }

    func returnDefaultBookMarkArray() -> [BookmarkData] {
        let titleArray = UserDefaults.standard.stringArray(forKey: "titleArray")
        let beanArray = UserDefaults.standard.array(forKey: "beanArray") as! [Int]
        let infoArray = UserDefaults.standard.stringArray(forKey: "infoArray")
        let dateArray = UserDefaults.standard.stringArray(forKey: "dateArray")
        let imageArray = UserDefaults.standard.array(forKey: "imageArray") as! [Data]
        
        var bookmarkArray: [BookmarkData] = []
        for x in 0..<titleArray!.count {
            let title1 = titleArray![x]
            let bean1 = beanArray[x]
            let info1 = infoArray![x]
            let date1 = dateArray![x]
            let image1 = UIImage(data: imageArray[x])
            
            let bookmark = BookmarkData(bean: bean1, title: title1, info: info1, date: date1, image: image1!)
            
            bookmarkArray.append(bookmark)
        }
        return bookmarkArray
    }
    
    func storeBookMarkArrayToUserDefaults(bmArray: [BookmarkData]){
        var titleArray: [String] = []
        var beanArray: [Int] = []
        var infoArray: [String] = []
        var dateArray: [String] = []
        var imageArray: [Data] = []
        
        for x in 0..<bmArray.count{
            titleArray.append(bmArray[x].title)
            beanArray.append(bmArray[x].bean)
            infoArray.append(bmArray[x].info)
            dateArray.append(bmArray[x].date)
            let image = bmArray[x].image
            let dataImage = image.pngData()
            imageArray.append(dataImage!)
        }
        
        UserDefaults.standard.setValue(titleArray, forKey: "titleArray")
        UserDefaults.standard.setValue(beanArray, forKey: "beanArray")
        UserDefaults.standard.setValue(infoArray, forKey: "infoArray")
        UserDefaults.standard.setValue(dateArray, forKey: "dateArray")
        UserDefaults.standard.setValue(imageArray, forKey: "imageArray")
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
