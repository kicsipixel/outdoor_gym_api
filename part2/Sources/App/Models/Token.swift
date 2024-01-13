//
//  Token.swift
//
//
//  Created by Szabolcs Tóth on 11.01.2024.
//  Copyright © 2024 Szabolcs Tóth. All rights reserved.
//

import Fluent
import Vapor

final class Token: Model, Content {
    static let schema = "tokens"
    
    @ID
    var id: UUID?
    
    @Field(key: "tokenValue")
    var tokenValue: String
    
    @Parent(key: "userID")
    var user: User
    
    init() { }
    
    init(id: UUID? = nil, tokenValue: String, userID: User.IDValue) {
        self.id = id
        self.tokenValue = tokenValue
        self.$user.id = userID
    }
}

extension Token {
    static func generate(for user: User) throws -> Token {
        let random = [UInt8].random(count: 32).base64
        return try Token(tokenValue: random, userID: user.requireID())
    }
}

extension Token: ModelTokenAuthenticatable {
    typealias User = App.User
    
    static let valueKey = \Token.$tokenValue
    static let userKey = \Token.$user
    
    var isValid: Bool {
        true
    }
}
