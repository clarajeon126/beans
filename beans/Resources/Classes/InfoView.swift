//
//  InfoView.swift
//  beans
//
//  Created by Clara Jeon on 3/28/21.
//

import UIKit

class InfoView: UIView {
    
    @IBOutlet weak var label: UILabel!
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
        self.backgroundColor = .red
        
    }
    
    required init?(coder aCoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        commonInit()
    }
    
    func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("InfoView", owner: self, options: nil)![0] as! UIView
        
        label.layoutSubviews()
        viewFromXib.backgroundColor = .red
        
        viewFromXib.frame = self.bounds
        self.addSubview(viewFromXib)
    }
    
}
