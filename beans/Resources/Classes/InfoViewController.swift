//
//  InfoViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/28/21.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var titleFill: String?
    var infoFill: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleFill
        
        infoLabel.text = infoFill
        
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
