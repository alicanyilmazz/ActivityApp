//
//  BaseTableViewCell.swift
//  ActivityApp
//
//  Created by alican on 12.03.2022.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellLeftIcon: UIImageView!
    @IBOutlet weak var cellLbl: UILabel!
    @IBOutlet weak var cellLeftLbl: UILabel!
    @IBOutlet weak var cellRightIcon: UIImageView!

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
        cellLbl.text = activityName
        cellLeftLbl.text = price
    }
    
    func setUIFeatures(status : Bool){
        if status{
            cellLeftIcon.tintColor = .systemBlue
        }else{
            cellLeftIcon.tintColor = .systemPink
        }
    }
}
