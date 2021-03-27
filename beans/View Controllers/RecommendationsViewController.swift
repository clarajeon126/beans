//
//  RecommendationsViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/27/21.
//

import UIKit

class RecommendationsViewController: UIViewController {

    @IBOutlet var beanButtons: [UIButton]!
    
    var beanPressed = ""
    @IBAction func artBeanTapped(_ sender: Any) {
        let bean = beanButtons[0]
        bean.layer.borderWidth = 2
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for x in 0..<beanButtons.count {
            let beanInQuestion = beanButtons[x]
            
            beanInQuestion.layer.cornerRadius = beanInQuestion.frame.height / 2
            
            beanInQuestion.layer.borderColor = UIColor.white.cgColor
        }
        
        
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
