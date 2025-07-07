//
//  Results.swift
//  BucketList
//
//  Created by DEEPAK BEHERA on 06/07/25.
//
import SwiftUI

struct Result: Codable {
    var query: Query
}
struct Query: Codable {
    var pages: [Int: Pages]
}
struct Pages: Codable, Comparable {
    var pageid: Int
    var title: String
    var terms: [String: [String]]?
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    
    static func <(lhs: Pages, rhs: Pages) -> Bool {
        return lhs.title < rhs.title
    }
}
enum LoadingState: String {
    case loading, loaded, failed
}
