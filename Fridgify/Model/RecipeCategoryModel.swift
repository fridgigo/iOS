//
//  RecipeCategoryModel.swift
//  Fridgify
//
//  Created by Murad Bayramli on 13.08.22.
//

import Foundation
import UIKit

struct RecipeCategoryModel {
    let image: UIImage
    let labelText: String
    
    init(image: UIImage, labelText: String) {
        self.image = image
        self.labelText = labelText
    }
    
}
