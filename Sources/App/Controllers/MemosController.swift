//
//  File.swift
//  SwiftServer
//
//  Created by dgsw30 on 3/21/25.
//

import Vapor
import JWT
import Fluent

struct MemosController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        _ = routes.grouped(UserAuthenticator())
        .grouped(Users.guardMiddleware())
        let memos = routes.grouped("memo")
        memos.get(use: getMyMemos)
        memos.post(use: createMemo)
    }
    
    
    func getMyMemos(_ req: Request) async throws -> CommonResponse<[MemoResponseDTO]> {
        let user = try req.auth.require(Users.self)
        let memos = try await Memo.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .all()
        
        let data = memos.map { MemoResponseDTO(title: $0.title, content: $0.content, createdAt: $0.createdAt) }
        return CommonResponse(
            status: 200,
            state: "OK",
            message: "내 글 조회 성공",
            data: data
        )
    }
    
    func createMemo(_ req: Request) async throws -> CommonResponse<MemoResponseDTO> {
        let user = try req.auth.require(Users.self)
        let input = try req.content.decode(CreateMemoDTO.self)
        
        let memo = Memo(title: input.title, content: input.content, userID: try user.requireID())
        try await memo.save(on: req.db)
        let data = MemoResponseDTO(title: memo.title, content: memo.content, createdAt: memo.createdAt)
        
        return CommonResponse(
            status: 200,
            state: "OK",
            message: "글쓰기 성공",
            data: data
        )
    }
}
