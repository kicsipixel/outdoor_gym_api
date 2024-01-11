//
//  UsersController.swift
//
//
//  Created by Szabolcs Tóth on 06.01.2024.
//  Copyright © 2024 Szabolcs Tóth. All rights reserved.
//

import Vapor

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("api", "v1", "users")
        
        users.get(use: index)
        users.post(use: create)
    }
    
    // MARK: - Create
    func create(_ req: Request) throws -> EventLoopFuture<User.Public> {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        return user.save(on: req.db).map {
            user.convertToPublic()
        }
    }
    
    // MARK: - Index
    //
    // Leaving this function here for testing purposes. Usually, you don't need to list all of the users in your application.
    //
    func index(req: Request) async throws -> [User.Public] {
        try await User.query(on: req.db).all().map {
            $0.convertToPublic()
        }
    }
}
