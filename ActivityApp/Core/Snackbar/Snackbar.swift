//
//  Snackbar.swift
//  ActivityApp
//
//  Created by alican on 12.03.2022.
//

import Foundation
import UIKit

class SnackbarView: UIView {
    
    let viewModel : SnackbarViewModel
    
    private var handler: Handler?
    
    private let label : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = label.font.withSize(12)
        return label
    }()
    
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    init(viewModel : SnackbarViewModel , frame : CGRect){
        self.viewModel = viewModel
        super.init(frame: frame)
        addSubview(label)
        if viewModel.image != nil{
        addSubview(imageView)
        }
        
        backgroundColor = UIColor.systemGray2.withAlphaComponent(0.4)
        
        clipsToBounds = true
        layer.cornerRadius = 15
        layer.masksToBounds = true
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func configure(){
        label.text = viewModel.text
        imageView.image = viewModel.image
        
        switch viewModel.type{
        case .action(let handler):
            self.handler = handler
            isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapSnackbar))
            gesture.numberOfTouchesRequired = 1
            gesture.numberOfTapsRequired = 1
            addGestureRecognizer(gesture)
        case .info : break
        
        }
    }
    
    @objc private func didTapSnackbar(){
        handler?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if viewModel.image != nil{
            imageView.frame = CGRect(x: 15, y: 15, width: frame.height-30, height: frame.height-30)
            label.frame = CGRect(x: imageView.frame.size.width, y: 0, width: frame.size.width - imageView.frame.size.width - 5 , height: frame.size.height)
        }else{
            
        }
    }
}

typealias Handler = (()-> Void)

enum SnackbarViewType{
    case info
    case action(handler : Handler)
}

struct SnackbarViewModel{
    let type : SnackbarViewType
    let text : String
    let image : UIImage?
    
    
}
