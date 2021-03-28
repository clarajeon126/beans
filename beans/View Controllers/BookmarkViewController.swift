//
//  BookmarkViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/27/21.
//

import UIKit

class BookmarkViewController: UIViewController {

    
    @IBOutlet weak var bookmarkTableView: UITableView!
    @IBOutlet weak var backToHomeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        backToHomeButton.layer.cornerRadius = backToHomeButton.frame.width / 2
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
        bookmarkTableView.register(UINib(nibName: "BookmarksTableViewCell", bundle: nil), forCellReuseIdentifier: "bookmarkCell")
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let bookmarkArray = returnDefaultBookMarkArray()
        return bookmarkArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookmarkArray = returnDefaultBookMarkArray()
        let cell = bookmarkTableView.dequeueReusableCell(withIdentifier: "bookmarkCell") as! BookmarksTableViewCell
        
        let bookmarkData = bookmarkArray[indexPath.row]
        
        cell.titleLabel.text = bookmarkData.title
        
        cell.bgView.backgroundColor = beanColorArray[bookmarkData.bean]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toSpecificBookmark", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSpecificBookmark" {
            let indexPath = bookmarkTableView.indexPathForSelectedRow
            let specificVC = segue.destination as! SpecificBookmarkViewController
            specificVC.numInArray = indexPath?.row as! Int
        }
    }
}
