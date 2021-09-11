//
//  ServiceProtocol.swift
//  ceiba
//
//  Created by William Lopez on 11/9/21.
//

import Foundation
import UIKit

typealias Parameters = [String: Any]
typealias HTTPHeaders = [String:String]

protocol ServiceProtocol {
    var path: String { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    var parametersEncoding: ParametersEncoding { get }
}

extension ServiceProtocol {
    
    var headers: HTTPHeaders? {
//        let headers: HTTPHeaders = [ "Content-Type" : "application/json" ]
//        let headers = ["":""]
        return headers
    }
}

// MARK: Protocol for the URLSessionProvider
protocol ProviderProtocol {
    func request<T>(type: T.Type, service: ServiceProtocol, completion: @escaping (Result<T, NetworkError>) -> ()) where T: Decodable
    func cancel()
}

// MARK: Http methods that the API supports
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

// MARK: Http task type for encoding
enum HTTPTask {
    case request
    case requestParameters( [URLQueryItem] )
    case requestWithObject( Encodable )
}

// MARK: Encoding types for creating the URLRequest
enum ParametersEncoding {
    case url
    case json
}
