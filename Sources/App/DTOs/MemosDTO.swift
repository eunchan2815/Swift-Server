//
//  File.swift
//  SwiftServer
//
//  Created by dgsw30 on 3/21/25.
//

import Vapor

struct CreateMemoDTO: Content {
    let title: String
    let content: String
}

struct MemoResponseDTO: Content {
//    let id: UUID?
    let title: String
    let content: String
    let createdAt: Date?
}
