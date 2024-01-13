//
//  CreateGymTableMigration.swift
//
//
//  Created by Szabolcs Toth on 11.12.2023.
//

import Fluent

struct CreateGymTableMigration: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("gyms")
            .id()
            .field("name", .string, .required)
            .field("coordinates_latitude", .float, .required)
            .field("coordinates_longitude", .float, .required)
            .field("userID", .uuid, .required, .references("users", "id"))
            .unique(on: "name") // in case you want unique names
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("gyms")
            .delete()
    }
}
