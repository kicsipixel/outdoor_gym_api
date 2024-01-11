//
//  CreateUserTableMigration.swift
//  
//
//  Created by Szabolcs Tóth on 06.01.2024.
//  Copyright © 2024 Szabolcs Tóth. All rights reserved.
//

import Fluent

struct CreateUserTableMigration: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("users")
            .id()
            .field("email", .string, .required)
            .field("password", .string, .required)
            .unique(on: "email")
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("users")
            .delete()
    }
}
