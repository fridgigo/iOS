//
//  Post.swift
//  Fridgify
//
//  Created by Murad Bayramli on 22.02.22.
//

import UIKit

struct PostsResponse: Codable {
    let status: Bool
    let posts: [Post]
}

struct Post: Codable {
    let _id: String
    let username: String
    let postHeader: String
    let postDescription: String?
    let createdAt: String
    let updatedAt: String
    //let likes: Int
    
}
