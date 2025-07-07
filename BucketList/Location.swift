//
//  Location.swift
//  BucketList
//
//  Created by DEEPAK BEHERA on 07/07/25.
//
import SwiftUI
import CoreLocation

struct Location: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    static let example = Location(id: UUID(), name: "Buckingham palace", description: "lit byo over 40,000 lightbulbs", latitude: 51.501, longitude: -0.141)
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
}
