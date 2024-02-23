import Fluent
import FluentPostgresDriver
import Vapor

// Configure your application
public func configure(_ app: Application) async throws {
    
    // MARK: - Local PostgreSQL database
    //   Configure DB connection
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
    
    // MARK: - Remote PostgreSQL database
    /*
     // Configure DB connection
     app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
     hostname: Environment.get("REMOTE_POSTGRES_DB") ?? "localhost",
     port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
     username: Environment.get("REMOTE_POSTGRES_USER") ?? "vapor_username",
     password: Environment.get("REMOTE_POSTGRES_PASSWORD") ?? "vapor_password",
     database: Environment.get("REMOTE_POSTGRES_USER") ?? "vapor_database",
     tls: .prefer(try .init(configuration: .clientDefault)))
     ), as: .psql)
     */
    
    // Migrations
    app.migrations.add(CreateUserTableMigration())
    app.migrations.add(CreateGymTableMigration())
    app.migrations.add(AddCityAndCountryToGymTableMigration())
    app.migrations.add(CreateTokenTableMigration())
    
    // Register routes
    try routes(app)
}
