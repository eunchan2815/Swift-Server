//
//  UserAuthenticator.swift
//  SwiftServer
//
//  Created by dgsw30 on 3/21/25.
//

import JWT
import Fluent
import Vapor

struct UserAuthenticator: AsyncBearerAuthenticator {
    typealias User = Users

    func authenticate(bearer: BearerAuthorization, for request: Request) async throws {
        let payload = try request.jwt.verify(bearer.token, as: UserPayload.self)
        
        guard let uuid = UUID(uuidString: payload.subject.value),
              let user = try await Users.find(uuid, on: request.db) else {
            return
        }

        request.auth.login(user)
    }
}
