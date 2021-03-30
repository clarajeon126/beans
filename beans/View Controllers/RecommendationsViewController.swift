//
//  RecommendationsViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/27/21.
//

import UIKit

class RecommendationsViewController: UIViewController {

    @IBOutlet var beanButtons: [UIButton]!
    
    @IBOutlet weak var backToHomeButton: UIButton!
    
    @IBOutlet weak var recommendTextView: UITextView!
    
    @IBOutlet var titles: [UILabel]!
    
    @IBOutlet weak var thankYouLabel: UILabel!
    
    //to set which bean it is for
    var beanPressed = "empty"
    var selectedButton: UIButton? = nil
    
    @IBAction func artBeanTapped(_ sender: Any) {
        beanButtonChange(num: 0)
    }
    
    @IBAction func chemBeanTapped(_ sender: Any) {
        beanButtonChange(num: 1)
    }
    
    @IBAction func homeBeanTapped(_ sender: Any) {
        beanButtonChange(num: 2)
    }
    @IBAction func itemHistoBeanTapped(_ sender: Any) {
        beanButtonChange(num: 3)
    }
    
    func beanButtonChange(num: Int){
        let beanButton = beanButtons[num]
        
        if beanPressed == "empty" {
            putABorder(button: beanButton)
            selectedButton = beanButton
            beanPressed = beanButton.titleLabel?.text ?? "empty"
        }
        else if beanPressed != beanButton.titleLabel?.text {
            eraseBorder(button: selectedButton!)
            putABorder(button: beanButton)
            selectedButton = beanButton
            
            beanPressed = beanButton.titleLabel?.text ?? "empty"
        }
        else {
            eraseBorder(button: beanButton)
            beanPressed = "empty"
        }
        
        print(beanPressed)
    }
    
    func putABorder(button : UIButton){
        button.layer.borderWidth = 2
    }
    func eraseBorder(button : UIButton){
        button.layer.borderWidth = 0
    }
    
    
    @IBAction func submitTapped(_ sender: Any) {
        if beanPressed != "empty" && !recommendTextView.text.isEmpty {
            for x in 0..<beanButtons.count {
                beanButtons[x].isHidden = true
            }
            
            for x in 0..<titles.count {
                titles[x].isHidden = true
            }
            recommendTextView.isHidden = true
            
            thankYouLabel.isHidden = false
            
            DatabaseManager.shared.addRecommend(bean: beanPressed, recommend: recommendTextView.text)
        }
        else {
            shakeButton(button: beanButtons[4])
        }
        
    }
    
    //shake a button
    func shakeButton(button: UIButton) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        button.layer.add(animation, forKey: "shake")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        recommendTextView.delegate = self
        recommendTextView.layer.cornerRadius = 10
        
        //back to home button as a circle
        backToHomeButton.layer.cornerRadius = backToHomeButton.frame.width / 2
        
        for x in 0..<beanButtons.count {
            let beanInQuestion = beanButtons[x]
            
            beanInQuestion.layer.cornerRadius = beanInQuestion.frame.height / 2
            
            beanInQuestion.layer.borderColor = UIColor.white.cgColor
        }
        
    }

}

extension RecommendationsViewController: UITextViewDelegate {
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
