//
//  Gym.swift
//
//
//  Created by Szabolcs Toth on 11.12.2023.
//

import Fluent
import Vapor

final class Coordinates: Fields, @unchecked Sendable {
    @Field(key: "latitude")
    var latitude: Float
    
    @Field(key: "longitude")
    var longitude: Float
    
    // Initialization
    init() { }
}

final class Gym: Model, Content, @unchecked Sendable {
    static let schema: String = "gyms"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Group(key: "coordinates")
    var coordinates: Coordinates
    
    @OptionalField(key: "city")
    var city: String?
    
    @OptionalField(key: "country")
    var country: String?
    
    @Parent(key: "userID") var user: User
    
    // Initialization
    init()  { }
    
    init(id: UUID? = nil, name:String, coordinates: Coordinates, city: String?, country: String?, userID: User.IDValue) {
        self.id = id
        self.name = name
        self.coordinates = coordinates
        self.city = city
        self.country = country
        self.$user.id = userID
    }
}
