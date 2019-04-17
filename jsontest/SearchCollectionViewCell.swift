//
//  SearchCollectionViewCell.swift
//  jsontest
//
//  Created by RS on 2019/03/22.
//  Copyright © 2019 RS. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet var icon:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.layer.cornerRadius =  100 / 2.0
        icon.clipsToBounds = true
        // Initialization code
    }

}
