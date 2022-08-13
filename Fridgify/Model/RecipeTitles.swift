//
//  RecipeTitles.swift
//  Fridgify
//
//  Created by Murad Bayramli on 31.07.22.
//

import Foundation


struct RecipeTitles: Codable {
    let status: Bool
    let data: [Recipe]
    
}

struct Recipe: Codable {
    let _id: String
    let title: String
}
