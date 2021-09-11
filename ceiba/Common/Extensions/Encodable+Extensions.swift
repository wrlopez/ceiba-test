//
//  Encodable+Extensions.swift
//  ceiba
//
//  Created by William Lopez on 11/9/21.
//

import Foundation

extension Encodable {
    func toJSONData() throws -> Data? {
        return try JSONEncoder().encode(self)
    }
}
