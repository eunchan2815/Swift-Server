//
//  TokenResponse.swift
//  SwiftServer
//
//  Created by dgsw30 on 3/20/25.
//

import Foundation
import Vapor

struct TokenResponseDTO: Content {
    let accessToken: String
    let refreshToken: String
}

struct RefreshTokenRequestDTO: Content {
    let refreshToken: String
}
