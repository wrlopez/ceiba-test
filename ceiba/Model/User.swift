//
//  User.swift
//  ceiba
//
//  Created by William Lopez on 10/9/21.
//

import Foundation

class User: Codable {
    var id: Int
    var name: String?
    var phone: String?
    var email: String?
    
    init(id: Int = 0) {
        self.id = id
    }
}
