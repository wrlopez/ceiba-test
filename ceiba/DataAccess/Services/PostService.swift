//
//  PostService.swift
//  ceiba
//
//  Created by William Lopez on 11/9/21.
//

import Foundation

enum PostService: ServiceProtocol {
    
    case getPosts( id: Int )
    
    var path: String {
        switch self {
        case .getPosts:
            return "posts"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPosts:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getPosts(id: let userId):
            let queryItem = URLQueryItem(name: "userId", value: String(userId))
            return .requestParameters([queryItem])
        }
    }
    
    var parametersEncoding: ParametersEncoding {
        switch self {
        case .getPosts:
            return .url
        }
    }
}
