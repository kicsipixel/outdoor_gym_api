import Fluent
import FluentPostgresDriver
import Vapor

// Configure your application
public func configure(_ app: Application) async throws {
    
    // MARK: - Local PostgreSQL database
    /*
    //  Get values from .env.development
    guard let username = Environment.get("POSTGRES_USER") else { return }
    guard let password = Environment.get("POSTGRES_PASSWORD") else { return }
    guard let database = Environment.get("POSTGRES_DB") else { return }
    
    //   Configure DB connection
    app.databases.use(.postgres(configuration: SQLPostgresConfiguration(hostname: "localhost",
                                                                        username: username,
                                                                        password: password,
                                                                        database: database,
                                                                        tls: PostgresConnection.Configuration.TLS.disable)),
                      as: .psql)
    
   */
    // MARK: - Remote PostgreSQL database
    guard let hostname = Environment.get("REMOTE_POSTGRES_DB") else { return }
    guard let username = Environment.get("REMOTE_POSTGRES_USER") else { return }
    guard let password = Environment.get("REMOTE_POSTGRES_PASSWORD") else { return }
    
    // Configure DB connection
    app.databases.use(.postgres(configuration: SQLPostgresConfiguration(hostname: hostname,
                                                                        username: username,
                                                                        password: password,
                                                                        database: username,
                                                                        tls: PostgresConnection.Configuration.TLS.disable)),
                      as: .psql)

    // Migrations
    app.migrations.add(CreateGymTableMigration())
    app.migrations.add(AddCityAndCountryToGymTableMigration())
    // Register routes
    try routes(app)
}
