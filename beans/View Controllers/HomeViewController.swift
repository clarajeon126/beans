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
        whiteCircleView.layer.cornerRadius = whiteCircleView.frame.width / 2
        
        beans.layer.cornerRadius = beans.frame.height/2
        bookmarks.layer.cornerRadius = bookmarks.frame.height/2
        recommendations.layer.cornerRadius = recommendations.frame.height/2
        beans.layer.shadowOffset = CGSize(width: 5, height: 5)
        beans.layer.shadowRadius = 10
        beans.layer.shadowOpacity = 1.0
        
        // Do any additional setup after loading the view.
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
