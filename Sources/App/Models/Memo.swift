//
//  File.swift
//  SwiftServer
//
//  Created by dgsw30 on 3/21/25.
//

import Fluent
import Vapor

final class Memo: Model, Content, @unchecked Sendable {
    static let schema = "memo"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "content")
    var content: String

    @Parent(key: "user_id")
    var user: Users

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() {}

    init(id: UUID? = nil, title: String, content: String, userID: UUID) {
        self.id = id
        self.title = title
        self.content = content
        self.$user.id = userID
    }
}

