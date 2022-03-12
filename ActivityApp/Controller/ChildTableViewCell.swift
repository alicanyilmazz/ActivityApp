//
//  ChildTableViewCell.swift
//  ActivityApp
//
//  Created by alican on 12.03.2022.
//

import UIKit

class ChildTableViewCell: UITableViewCell {

    @IBOutlet weak var lblLeftIcon: UIImageView!
    @IBOutlet weak var paymentLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var lblRightIcon: UIImageView!
    
    @IBOutlet weak var eachView: UIView!
    @IBOutlet weak var outsideView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAttributes(activityName : String , price : String){
        paymentLbl.text = activityName
        costLbl.text = price
    }
    
    func setUIFeatures(){
        eachView.layer.cornerRadius = 15
        eachView.clipsToBounds = false
        eachView.layer.shadowOpacity = 0.3
        eachView.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
    }

}
