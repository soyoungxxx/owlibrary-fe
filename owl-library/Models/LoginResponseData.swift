//
//  LoginResponseData.swift
//  owl-library
//
//  Created by 하소영 on 3/31/25.
//

import Foundation

struct LoginResponseData : Codable {
    let data: LoginData?
    let message: String
    let result: String
    
}

// MARK: - DataClass
struct LoginData : Codable {
    let accessToken: String
    let refreshToken: String
}
