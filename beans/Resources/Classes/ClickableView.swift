//
//  ClickableView.swift
//  beans
//
//  Created by Clara Jeon on 3/28/21.
//

import UIKit

/// Clickable View
class ClickableView: UIButton{

    override init(frame: CGRect) {

    super.init(frame: frame)

    self.addTarget(self, action:  #selector(objectTapped(_:)), for: .touchUpInside)

    self.backgroundColor = .gray

}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

/// Detects Which Object Was Tapped
///
/// - Parameter sender: UIButton
@objc func objectTapped(_ sender: UIButton){
    
    print("Object With Tag \(tag)")
   }
}
