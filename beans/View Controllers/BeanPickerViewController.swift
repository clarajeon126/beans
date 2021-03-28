//
//  BeanPickerViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/27/21.
//

import UIKit

class BeanPickerViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var backToHomeButtons: [UIButton]!
    
    @IBOutlet var smallCircles: [UIView]!
    
    @IBOutlet var circleWithBorder: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for x in 0..<backToHomeButtons.count{
            backToHomeButtons[x].layer.cornerRadius = backToHomeButtons[x].frame.width / 2.2
            
        }
        
        for x in 0..<smallCircles.count{
            smallCircles[x].layer.cornerRadius = smallCircles[x].frame.width / 2
        }
        
        for x in 0..<circleWithBorder.count{
            let circleInQuesiton = circleWithBorder[x]
            circleInQuesiton.layer.borderColor = UIColor.white.cgColor
            circleInQuesiton.layer.borderWidth = 5
        }
        
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
