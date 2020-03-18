//
//  CollectionViewCell.swift
//  Camera&PhotoLibraryTest
//
//  Created by 深瀬貴将 on 2020/03/19.
//  Copyright © 2020 深瀬 貴将. All rights reserved.
//

import UIKit
import Instantiate
import InstantiateStandard

class CollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
