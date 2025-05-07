//
//  File.swift
//  SwiftServer
//
//  Created by dgsw30 on 3/20/25.
//

import Fluent
import Vapor

final class Users: Model, Content, @unchecked Sendable, Authenticatable {
    static let schema = "user"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    init() { }
    
    init(id: UUID? = nil, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}

extension Users {
    static func authenticator() -> UserAuthenticator {
        return UserAuthenticator()
    }
}

