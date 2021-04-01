//
//  InfoViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/28/21.
//

import UIKit

class InfoViewController: UIViewController {
    
    var numPressed = 0
    @IBAction func bookmarkTapped(_ sender: Any) {
        
        print("pressed bookmarks")
        var storedBookmarks = returnDefaultBookMarkArray()
        
        for x in 0..<storedBookmarks.count {
            print(storedBookmarks[x].title)
        }
        
        let newBookMark = BookmarkData(bean: beanNum ?? 0, title: titleFill ?? "no title", info: infoFill ?? "info")
        storedBookmarks.append(newBookMark)
        
        print("new bookmark title: \(newBookMark.title)")
        var newBookmarkArray = storedBookmarks
        storeBookMarkArrayToUserDefaults(bmArray: newBookmarkArray)
        
    }
    
    @IBAction func expandButtonTapped(_ sender: Any) {
        
        let changeToAppear = numPressed % 2 == 0
        
        if infoView.isHidden {
            infoView.isHidden = false
            
            //backgroundView.layer.cornerRadius = 0
            //self.view.frame = CGRect(x: 0, y: 0, width: 450, height: 500)
            
        }
        else {
            //self.view.frame = CGRect(x: 0, y: 0, width: 450, height: 100)
            infoView.isHidden = true
        }
        
        numPressed += 1
    }
    
    @IBOutlet var overallView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var titleBackGroundView: UIView!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet weak var expandButton: UIButton!
    
    @IBOutlet weak var backgroundView: UIView!
    var titleFill: String?
    var infoFill: String?
    var beanNum: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //set title and inf
        titleLabel.text = titleFill
        infoLabel.text = infoFill
        
        //set above bg
        backgroundView.backgroundColor = beanColorArray[beanNum ?? 0]
        
        //set below bg
        infoView.backgroundColor = beanColorArray[beanNum ?? 0]
        
        //set title label bg
        titleBackGroundView.backgroundColor = beanLighterColorArray[beanNum ?? 0]
        
        
        //set info label bg
        infoLabel.backgroundColor = beanLighterColorArray[beanNum ?? 0]
        
        //set rounded corners
        bookmarkButton.layer.cornerRadius = bookmarkButton.frame.width / 2
        expandButton.layer.cornerRadius = expandButton.frame.width / 2
        titleBackGroundView.layer.cornerRadius = titleBackGroundView.frame.height / 2
        
        infoLabel.layer.cornerRadius = infoLabel.frame.height / 2
    
        //set background cornerRadius
        backgroundView.layer.cornerRadius = 10
        infoView.layer.cornerRadius = 10
    }

    func returnDefaultBookMarkArray() -> [BookmarkData] {
        if let titleArray = UserDefaults.standard.stringArray(forKey: "titleArray"),
           let beanArray = UserDefaults.standard.array(forKey: "beanArray") as? [Int],
        let infoArray = UserDefaults.standard.stringArray(forKey: "infoArray"),
        let dateArray = UserDefaults.standard.stringArray(forKey: "dateArray"),
        let imageArray = UserDefaults.standard.array(forKey: "imageArray") as? [Data] {
            var bookmarkArray: [BookmarkData] = []
            for x in 0..<titleArray.count {
                let title1 = titleArray[x]
                let bean1 = beanArray[x]
                let info1 = infoArray[x]
                let date1 = dateArray[x]
                let image1 = UIImage(data: imageArray[x])
                
                let bookmark = BookmarkData(bean: bean1, title: title1, info: info1, date: date1, image: image1!)
                
                bookmarkArray.append(bookmark)
            }
            return bookmarkArray
        }
        else {
            let emptyBookmarkArray: [BookmarkData] = []
            return emptyBookmarkArray
        }
        
        
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
            print(bmArray[x].title)
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
