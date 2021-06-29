//
//  AdvanceFood.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/28/21.
//

import Foundation

struct AdvanceFood: Codable {
    let id: Int
    let inWishlist: Bool
    let isActive: Bool
    let category: String
    let size: String
    let name: String
    let picture: String
    let quantity: Int
    let salesNumber: Int
    let price: Float
    let discount: Int
    let score: Float
    let votersNumber: Int
    let details: String
    let preparationTime: Int
    let comments: [Comment]
}

struct Comment: Codable {
    let user: User_Slice
    let content: String
    let createAt: String
}

struct User_Slice: Codable {
    let isMarketer: Bool
    let nickname: String
    let profilePicture: String
}
