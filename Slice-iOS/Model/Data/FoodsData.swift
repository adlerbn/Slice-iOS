//
//  FoodsData.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/25/21.
//

import Foundation

struct FoodsData: Codable {
    let page: Int
    let count: Int
    let foodItems: [Food]
}

struct Food: Codable {
    let id: Int
    let isActive: Bool
    let name: String
    let picture: String
    let price: Float
    let discount: Int
    let score: Float
    let details: String
    let preparationTime: Int
}

enum Category: String {
    case Pizza = "Pizza"
    case Sandwich = "Sandwich"
    case Baverage = "Baverage"
    case Salad = "Salad"
    case Appetizer = "Appetizer"
    case Sauce = "Sauce"
    case none = ""
}

enum Size: String {
    case Small = "Small"
    case Medium = "Medium"
    case Large = "Large"
    case Extralarge = "Extralarge"
    case none = ""
}

enum IsActive: String {
    case False = "false"
    case True = "true"
    case none = ""
}
