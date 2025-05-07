//
//  File.swift
//  SwiftServer
//
//  Created by dgsw30 on 3/20/25.
//

import Vapor

struct UserSignupDTO: Content {
    let email: String
    let password: String
}

struct UserLoginDTO: Content {
    let email: String
    let password: String
}

struct UserInfoDTO: Content {
    let email: String
    let password: String
}
