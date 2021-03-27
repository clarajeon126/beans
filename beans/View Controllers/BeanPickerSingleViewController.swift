//
//  BeanPickerSingleViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/27/21.
//

import UIKit

class BeanPickerSingleViewController: UIViewController {

    @IBOutlet weak var buttonHome: UIButton!
    
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //make it a circular button
        buttonHome.layer.cornerRadius = buttonHome.frame.width / 2
        
        
        
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
