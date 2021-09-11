//
//  URLSessionProvider.swift
//  ceiba
//
//  Created by William Lopez on 11/9/21.
//

import Foundation

final class NetworkProvider {
    
    private var session: URLSession
    private var task: URLSessionTask?
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<T>( type: T.Type, service: ServiceProtocol, completion: @escaping (Result<T, NetworkError>) -> () ) where T: Decodable {
        if let request = createRequest(service: service) {
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                let httpResponse = response as? HTTPURLResponse
                self.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
            })
            task?.resume()
        }
    }
    
    func cancel() {
        task?.cancel()
    }
    
    private func createRequest( service: ServiceProtocol ) -> URLRequest? {
        var request: URLRequest?
        var components: URLComponents?
        
        if let url = URL(string: Constants.System.baseUrl)?.appendingPathComponent(service.path) {
            components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
            if case let .requestParameters(queryItems) = service.task, service.parametersEncoding == .url {
                components?.queryItems = queryItems
            }
        }
        
        if let url = components?.url {
            request = URLRequest(url: url)
            request?.httpMethod = service.method.rawValue
            
            if case let .requestWithObject(entity) = service.task, service.parametersEncoding == .json {
                do {
                    request?.httpBody = try entity.toJSONData()
                } catch {
                    print("Encoding error", error.localizedDescription)
                }
            }
        }
        
        return request
    }
    
    private func handleDataResponse<T: Decodable>(data: Data?, response: HTTPURLResponse?, error: Error?, completion: (Result<T, NetworkError>) -> ()) {
        
        guard error == nil else {
            print(error as Any)
            return completion(.failure(.networkError))
        }
        guard let response = response else { return completion(.failure(.noJSONData)) }
        
        switch response.statusCode {
            
        case 200...299:
            
            if let data = data {
                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(model))
                } catch {
                    print(error.localizedDescription, "ERROR:", error)
                    completion(.failure(.decodeError))
                }
            }
            
        case 400...599:
            if let data = data {
                do {
                    if let jsonError = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        print(jsonError)
                        completion(.failure(.unknown))
                    }
                } catch {
                    print("Error parsing the json \(error.localizedDescription)")
                    completion(.failure(.unknown))
                }
            }
            
        default:
            completion(.failure(.unknown))
        }
        
    }
    
}


//final class URLSessionProvider: ProviderProtocol {
    
//    private var session: URLSessionProtocol
    
//    init(session: URLSessionProtocol = URLSession.shared) {
//        self.session = session
//    }
    
    
//    func request<T>(type: T.Type, service: ServiceProtocol, completion: @escaping (NetworkResponse<T>) -> ()) where T: Decodable {
//        let request = URLRequest(service: service)
//        //let task1 = session.dataTask(request: request) { [weak self] data, response, error in
//        task = session.dataTask(request: request) { (data, response, error) in
//            let httpResponse = response as? HTTPURLResponse
//            self.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
//        }
//        task?.resume()
//    }
    
//}
