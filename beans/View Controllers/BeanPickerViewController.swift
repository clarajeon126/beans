//
//  BeanPickerViewController.swift
//  beans
//
//  Created by Clara Jeon on 3/27/21.
//

import UIKit

class BeanPickerViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var pages = [BeanPickerSingleViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let artBean = createAndAddOtherView(num: 0)
        let chemBean = createAndAddOtherView(num: 1)
        let homeBean = createAndAddOtherView(num: 2)
        let itemHistoBean = createAndAddOtherView(num: 3)
        
        scrollView.contentSize.width = UIScreen.main.bounds.width * 4
        pages = [artBean, chemBean, homeBean, itemHistoBean]
        
        let views: [String: UIView] = ["view": view, "artBean": artBean.view , "chemBean": chemBean.view , "homeBean": homeBean.view , "itemHistoBean": itemHistoBean.view]
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[artBean(==view)]|", options: [], metrics: nil, views: views)
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[artBean(==view)][chemBean(==view)][homeBean(==view)][itemHistoBean(==view)]", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(verticalConstraints + horizontalConstraints)
    }
    

    private func createAndAddOtherView(num: Int) -> BeanPickerSingleViewController{
        
        //create new bean picker single view controller
        let newView = storyboard!.instantiateViewController(identifier: "BeanPickerSingleViewController") as! BeanPickerSingleViewController
        
        newView.view.translatesAutoresizingMaskIntoConstraints = false
        
        //each num corresponds with a view 0 is artbean, 1 chembean, 2 homebean. 3 itemhistobean
        
        //setting the background color
        let circleOfView = newView.circleViewArray[num]
        
        let mainColor = circleOfView.backgroundColor
        
        circleOfView.backgroundColor = UIColor.white
        
        newView.backgroundView.backgroundColor = mainColor
        
        if num == 0 {
            newView.mainBeanImage.image = #imageLiteral(resourceName: "art bean")
        }
        else if num == 1 {
            newView.buttonToAr.setImage(#imageLiteral(resourceName: "chem bean"), for: .normal)
        }
        else if num == 2 {
            newView.buttonToAr.setImage(#imageLiteral(resourceName: "house bean"), for: .normal)
        }
        else {
            newView.buttonToAr.setImage(#imageLiteral(resourceName: "item histo bean"), for: .normal)
        }
        
        scrollView.addSubview(newView.view)
        
        addChild(newView)
        
        newView.didMove(toParent: self)
        return newView
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
