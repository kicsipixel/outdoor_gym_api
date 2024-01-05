//
//  AddCityAndCountryToGymTableMigration.swift
//
//
//  Created by Szabolcs Tóth on 16.12.2023.
//  Copyright © 2023 Szabolcs Tóth. All rights reserved.
//

import Fluent

struct AddCityAndCountryToGymTableMigration: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("gyms")
            .field("city", .string)
            .field("country", .string)
            .update()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("gyms")
            .deleteField("city")
            .deleteField("country")
            .update()
    }
}

