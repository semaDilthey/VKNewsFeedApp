//
//  UserResponse.swift
//  VkNewsApp
//
//  Created by Семен Гайдамакин on 22.06.2023.
//

import Foundation
import UIKit

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
}
