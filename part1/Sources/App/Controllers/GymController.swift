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
        
        gyms.get(use: index)
        gyms.post(use: create)
        gyms.get(":id", use: show)
        gyms.put(":id", use: update)
        gyms.delete(":id", use: delete)
    }
    
    // MARK: - Index
    func index(req: Request) async throws -> [Gym] {
        try await Gym.query(on: req.db).all()
    }
    
    // MARK: - Create
    func create(req: Request) async throws -> Gym {
        let gym = try req.content.decode(Gym.self)
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
        
        let updatedGym = try req.content.decode(Gym.self)
        
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
        
        try await gym.delete(on: req.db)
        
        return gym
    }
}
