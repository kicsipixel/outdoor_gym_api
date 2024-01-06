//
//  User.swift
//
//
//  Created by Szabolcs Tóth on 06.01.2024.
//  Copyright © 2024 Szabolcs Tóth. All rights reserved.
//

import Fluent
import Vapor

final class User: Model {
    static let schema: String = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    init() { }
    
    init(id: UUID? = nil, username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
    }
}
