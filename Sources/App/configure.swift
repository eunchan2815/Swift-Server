import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor
import JWT

public func configure(_ app: Application) async throws {
    let secretKey = Environment.get("JWT_SECRET") ?? "secret"
    app.jwt.signers.use(.hs256(key: secretKey))
    
    let corsConfig = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith]
    )
    let cors = CORSMiddleware(configuration: corsConfig)
    app.middleware.use(cors)  // 👈 미들웨어 등록
    
    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: "localhost",
        port: 3307,
        username: "root",
        password: "1234",
        database: "swiftserver",
        tlsConfiguration: .forClient(certificateVerification: .none)
    ), as: .mysql)
    
    app.middleware.use(UserAuthenticator())
    try routes(app)
}
