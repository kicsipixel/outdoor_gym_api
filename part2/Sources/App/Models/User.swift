//
//  User.swift
//
//
//  Created by Szabolcs Tóth on 06.01.2024.
//  Copyright © 2024 Szabolcs Tóth. All rights reserved.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema: String = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Children(for: \.$user) var gyms: [Gym]
    
    init() { }
    
    init(id: UUID? = nil, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
    
    final class Public: Content {
        var id: UUID?
        var email: String
        
        init(id: UUID?, email: String) {
            self.id = id
            self.email = email
        }
    }
}

extension User {
    func convertToPublic() -> User.Public {
        return User.Public(id: id, email: email)
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
