//
//  File.swift
//  SwiftServer
//
//  Created by dgsw30 on 3/20/25.
//

import Vapor
import Fluent
import JWT

struct UsersController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let userRoutes = routes.grouped("auth")
        userRoutes.post("signup", use: signup)
        userRoutes.post("login", use: login)
        userRoutes.get("me", use: userInfo)
        userRoutes.post("reissue", use: reissue)
    }
    
    
    //회원가입
    func signup(req: Request) async throws -> CommonResponse<EmptyData> {
        let signupData = try req.content.decode(UserSignupDTO.self)
        
        let user = Users(email: signupData.email, password: signupData.password)
        try await user.save(on: req.db)
        
        return CommonResponse(
            status: 200,
            state: "OK",
            message: "회원가입 성공",
            data: EmptyData()
        )
    }
    
    
    //로그인
    func login(req: Request) async throws -> CommonResponse<TokenResponseDTO> {
        let loginData = try req.content.decode(UserLoginDTO.self)
        
        guard let user = try await Users.query(on: req.db)
            .filter(\.$email == loginData.email)
            .filter(\.$password == loginData.password)
            .first()
        else {
            throw Abort(.unauthorized, reason: "비번이 잘못되었습니다.")
        }
        
        let accessToken = try generateJWTToken(for: user, on: req)
        let refreshToken = try generateRefreshToken(for: user, on: req)
        let data = TokenResponseDTO(accessToken: accessToken, refreshToken: refreshToken)
        
        return CommonResponse(
            status: 200,
            state: "OK",
            message: "로그인 성공",
            data: data
        )
    }
    
    
    //유저 정보
    func userInfo(req: Request) async throws -> CommonResponse<UserInfoDTO> {
        let userInfo = try req.auth.require(Users.self)
        let data = UserInfoDTO(email: userInfo.email, password: userInfo.password)
        return CommonResponse(
            status: 200,
            state: "OK",
            message: "내정보 불러오기 성공",
            data: data
        )
    }
    
    
    //토큰 재발급
    func reissue(req: Request) async throws -> CommonResponse<TokenResponseDTO> {
        let tokenData = try req.content.decode(RefreshTokenRequestDTO.self)
        
        // 1. 리프레시 토큰 검증
        let payload = try req.jwt.verify(tokenData.refreshToken, as: UserPayload.self)
        
        // 2. 유저 조회
        guard let uuid = UUID(uuidString: payload.subject.value),
              let user = try await Users.find(uuid, on: req.db) else {
            throw Abort(.unauthorized, reason: "유효하지 않은 토큰입니다.")
        }
        
        // 3. 새 토큰 생성
        let newAccessToken = try generateJWTToken(for: user, on: req)
        let newRefreshToken = try generateRefreshToken(for: user, on: req)
        
        let data = TokenResponseDTO(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken
        )
        
        return CommonResponse(
            status: 200,
            state: "SUCCESS",
            message: "토큰 재발급 성공",
            data: data
        )
    }
}
