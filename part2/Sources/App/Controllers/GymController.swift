//
//  GymController.swift
//
//
//  Created by Szabolcs Tóth on 11.12.2023.
//  Copyright © 2023 Szabolcs Tóth. All rights reserved.
//

import Fluent
import Vapor

struct GymController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let gyms = routes.grouped("api", "v1", "gyms")
        
        // Non-protected routes
        gyms.get(use: index)
        gyms.get(":id", use: show)
        
        // Middleware
        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        let tokenAuthGroup = gyms.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        // Protected routes
        tokenAuthGroup.post(use: create)
        tokenAuthGroup.put(":id", use: update)
        tokenAuthGroup.delete(":id", use: delete)
        tokenAuthGroup.get("user", use: getAllGymByUser)
    }
    
    // MARK: - Index
    func index(req: Request) async throws -> [Gym] {
        return try await Gym.query(on: req.db).all()
    }
    
    //
    // For testing purposes, a function, which lists the gyms created by the user
    //
    func getAllGymByUser(_ req: Request) async throws -> [Gym] {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        
        return try await Gym.query(on: req.db).filter(\.$user.$id == userID).all()
    }
    
    // MARK: - Create
    func create(req: Request) async throws -> Gym {
        let user = try req.auth.require(User.self)
        let data = try req.content.decode(CreateGymData.self)
        let gym = try Gym(name: data.name, coordinates: data.coordinates, city: data.city, country: data.country, userID: user.requireID())
        try await gym.save(on: req.db)
        
        return gym
    }
    
    // MARK: - Show
    func show(req: Request) async throws -> Gym {
        guard let gym = try await Gym.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
                
        return gym
    }
    
    
    // MARK: - Update
    func update(req: Request) async throws -> Gym {
        guard let gym = try await Gym.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try req.auth.require(User.self)
        let updatedGym = try req.content.decode(CreateGymData.self)
        
        gym.name = updatedGym.name
        gym.coordinates.latitude = updatedGym.coordinates.latitude
        gym.coordinates.longitude = updatedGym.coordinates.longitude
        gym.city = updatedGym.city
        gym.country = updatedGym.country
        try await gym.save(on: req.db)
        
        return gym
    }
    
    // MARK: - Delete
    func delete(req: Request) async throws -> Gym {
        guard let gym = try await Gym.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try req.auth.require(User.self)
        try await gym.delete(on: req.db)
        
        return gym
    }
}

struct CreateGymData: Content {
    let name: String
    let coordinates: Coordinates
    let city: String
    let country: String
}


