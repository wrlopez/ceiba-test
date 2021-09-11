//
//  Post.swift
//  ceiba
//
//  Created by William Lopez on 10/9/21.
//

import Foundation

class Post: Codable {
    var id: Int
    var userId: Int
    var title: String?
    var body: String?
    
    init( id: Int = 0, userId: Int = 0 ) {
        self.id = id
        self.userId = userId
    }
}
