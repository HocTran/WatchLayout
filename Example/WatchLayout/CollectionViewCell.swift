//
//  CollectionViewCell.swift
//  WatchLayout_Example
//
//  Created by Hoc Tran on 07.02.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = bounds.height * 0.5
    }
}
