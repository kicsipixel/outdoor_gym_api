//
//  CreateTokenTableMigration.swift
//
//
//  Created by Szabolcs Tóth on 11.01.2024.
//  Copyright © 2024 Szabolcs Tóth. All rights reserved.
//

import Fluent

struct CreateTokenTableMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tokens")
            .id()
            .field("tokenValue", .string, .required)
            .field("userID", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tokens")
            .delete()
    }
}
