//
//  File.swift
//  SwiftServer
//
//  Created by dgsw30 on 3/20/25.
//

import JWT
import Vapor
import Foundation

struct UserPayload: JWTPayload {
    var subject: SubjectClaim
    var expiration: ExpirationClaim

    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
}

extension UsersController {
    func generateJWTToken(for user: Users, on req: Request) throws -> String {
        let exp = ExpirationClaim(value: Date().addingTimeInterval(3600))
        let payload = UserPayload(subject: .init(value: user.id!.uuidString), expiration: exp)
        return try req.jwt.sign(payload)
    }

    func generateRefreshToken(for user: Users, on req: Request) throws -> String {
        let exp = ExpirationClaim(value: Date().addingTimeInterval(604800))
        let payload = UserPayload(subject: .init(value: user.id!.uuidString), expiration: exp)
        return try req.jwt.sign(payload)
    }
}
