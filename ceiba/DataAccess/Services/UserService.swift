//
//  UserService.swift
//  ceiba
//
//  Created by William Lopez on 11/9/21.
//

import Foundation

enum UserService: ServiceProtocol {
    
    case getUsers
    
    var path: String {
        switch self {
        case .getUsers:
            return "users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getUsers:
            return .request
        }
    }
    
//    var headers: HTTPHeaders?
    
    var parametersEncoding: ParametersEncoding {
        switch self {
        case .getUsers:
            return .url
        }
    }
    
}
