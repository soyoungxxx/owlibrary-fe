//
//  LoginResponseData.swift
//  owl-library
//
//  Created by 하소영 on 3/31/25.
//

import Foundation

struct LoginResponseData : Codable {
    let status: Int
    let message: String
    let data: LoginData
}

struct LoginData : Codable {
    let accessToken: String
    let refreshToken: String?
}
