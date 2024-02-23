# Part 1

In case you want to use local PostgreSQL DB with Docker Compose, `configure.swift`:

```swift
public func configure(_ app: Application) async throws {
    
    // MARK: - Local PostgreSQL database
    // Configure local DB connection
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
    
    
    // Migrations
    app.migrations.add(CreateGymTableMigration())
    app.migrations.add(AddCityAndCountryToGymTableMigration())
    // Register routes
    try routes(app)
}

```

The `.env.development` and `.env.production` files are the following:

```
# Local PostgreSQL database using docker
DATABASE_HOST=db
DATABASE_NAME=vapor_database
DATABASE_USERNAME=vapor_usernam3
DATABASE_PASSWORD=vapor_passw0rd
PGDATA=/var/lib/postgresql/data/pgdata
POSTGRES_USER=vapor_usernam3
POSTGRES_PASSWORD=vapor_passw0rd
POSTGRES_DB=vapor_database
POSTGRES_HOST=localhost

# Remote PostgreSQL database using Elephantsql.com
REMOTE_POSTGRES_USER=jssstcdn
REMOTE_POSTGRES_PASSWORD=JKK2wHwQEG9vK5kXIJwNql2-ZGU1EEA4
REMOTE_POSTGRES_DB=flora.db.elephantsql.com
```

### Step 1. Build

`$ docker-compose build`

### Step 2. Run

`$ docker-compose up app`

### Step 3. Migrate

`$ docker-compose run migrate`