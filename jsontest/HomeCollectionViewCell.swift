//
//  HomeCollectionViewCell.swift
//  jsontest
//
//  Created by RS on 2019/03/18.
//  Copyright © 2019 RS. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var iconActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var topActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var leftActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var rightActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var icon:UIImageView!
    @IBOutlet var top:UIImageView!
    @IBOutlet var left:UIImageView!
    @IBOutlet var right:UIImageView!
    @IBOutlet var userLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        icon.layer.cornerRadius =  35 / 2.0
        icon.clipsToBounds = true
        top.layer.cornerRadius = 170 / 2.0
        top.clipsToBounds = true
        left.layer.cornerRadius = 170 / 2.0
        left.clipsToBounds = true
        right.layer.cornerRadius = 170 / 2.0
        right.clipsToBounds = true
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
    }
    

}
