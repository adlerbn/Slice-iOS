//
//  ActivityData.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/23/21.
//

import Foundation

struct ActivityData: Codable {
    let token: String
    let user: User
}

struct User: Codable {
    let isMarketer: Bool
    let nickname: String
    let profilePicture: String
//    let phone: String
    let email: String
    let locations: [Location]
}

struct Location: Codable {
    let locationName: String
    let latitude: Double
    let longitude: Double
}
