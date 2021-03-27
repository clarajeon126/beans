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
