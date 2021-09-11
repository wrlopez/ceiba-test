//
//  NetworkError.swift
//  ceiba
//
//  Created by William Lopez on 11/9/21.
//

import Foundation

enum NetworkError: String, Error {
    case unknown = "An unknown error has occurred"
    case noJSONData = "The server did not sent any response"
    case decodeError = "There was an error decoding the response"
    case networkError = "A network error has occurred please check your connection and try again"
    
}
