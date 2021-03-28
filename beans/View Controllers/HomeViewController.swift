//
//  HomeViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/27/21.
//

import UIKit

class HomeViewController: UIViewController {

    
    
    @IBOutlet weak var beans: UIButton!
    
    @IBOutlet weak var bookmarks: UIButton!
    
    @IBOutlet weak var recommendations: UIButton!
    
    
    @IBOutlet weak var whiteCircleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //changing white view to a circle
        whiteCircleView.layer.cornerRadius = whiteCircleView.frame.height / 2.2
        
        //bean stuff
        beans.layer.cornerRadius = beans.frame.height/2
        beans.layer.shadowOffset = CGSize(width: 5, height: 5)
        beans.layer.shadowRadius = 5
        beans.layer.shadowOpacity = 1.0
        beans.layer.shadowColor = CGColor(red: 163.0/255.0, green: 229.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        
        //ookmarks stuff
        
        bookmarks.layer.cornerRadius = bookmarks.frame.height/2
        bookmarks.layer.shadowOffset = CGSize(width: 5, height: 5)
        bookmarks.layer.shadowRadius = 5
        bookmarks.layer.shadowOpacity = 1.0
        bookmarks.layer.shadowColor = CGColor(red: 249.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1.0)
        
        
        //recomendation stuff
        recommendations.layer.cornerRadius = recommendations.frame.height/2
        recommendations.layer.shadowOffset = CGSize(width: 5, height: 5)
        recommendations.layer.shadowRadius = 5
        recommendations.layer.shadowOpacity = 1.0
        recommendations.layer.shadowColor = CGColor(red: 249.0/255.0, green: 207.0/255.0, blue: 44.0/255.0, alpha: 1.0)
        
       
        let newBookmark = BookmarkData(bean: 0, title: "title 1", info: "info blah blah blah")
        let newBookmark1 = BookmarkData(bean: 1, title: "title 2", info: "info blah blah blah")
        let newBookmark2 = BookmarkData(bean: 2, title: "title 3", info: "info blah blah blah")
        let newBookmark3 = BookmarkData(bean: 3, title: "title 4", info: "info blah blah blah")
        let newBookmark4 = BookmarkData(bean: 0, title: "title 5", info: "info blah blah blah")
        
        let bookMarkArrayTemp: [BookmarkData] = [newBookmark, newBookmark1, newBookmark2, newBookmark3, newBookmark4]
        

        storeBookMarkArrayToUserDefaults(bmArray: bookMarkArrayTemp)
        
        
        
        // Do any additional setup after loading the view.
    }
    

    func storeBookMarkArrayToUserDefaults(bmArray: [BookmarkData]){
        var titleArray: [String] = []
        var beanArray: [Int] = []
        var infoArray: [String] = []
        var dateArray: [String] = []
        //var imageArray: [UIImage] = []
        
        for x in 0..<bmArray.count{
            titleArray.append(bmArray[x].title)
            beanArray.append(bmArray[x].bean)
            infoArray.append(bmArray[x].info)
            dateArray.append(bmArray[x].date)
            //imageArray.append(bmArray[x].image)
        }
        
        UserDefaults.standard.setValue(titleArray, forKey: "titleArray")
        UserDefaults.standard.setValue(beanArray, forKey: "beanArray")
        UserDefaults.standard.setValue(infoArray, forKey: "infoArray")
        UserDefaults.standard.setValue(dateArray, forKey: "dateArray")
        //UserDefaults.standard.setValue(imageArray, forKey: "imageArray")
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
