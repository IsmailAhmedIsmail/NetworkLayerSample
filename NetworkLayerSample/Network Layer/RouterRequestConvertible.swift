//
//  RouterRequestConvertible.swift
//  NetworkLayerSample
//
//  Created by Ismail Ahmed on 12/18/18.
//  Copyright © 2018 LinkDev. All rights reserved.
//

import Alamofire
typealias QueryItems = [String : String]
protocol RouterRequestConvertible: URLRequestConvertible {
    
    var method: HTTPMethod { get }
    var endPoint: EndPoint { get }
    var queryItems: QueryItems? { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var environment : Environment { get }
    
}

extension RouterRequestConvertible {
    
    private var baseHeaders : [String : String] {
        return [
           "Content-Type" : "application/json",
           "Accept" : "application/json"
        ]
    }
    
    func asURLRequest() throws -> URLRequest {
        
        // URL Components
        var components = environment.components
        components.path = endPoint.subdomain + endPoint.path
        
        var items = [URLQueryItem]()
        queryItems?.forEach { items.append(URLQueryItem(name: $0, value: $1)) }
        components.queryItems = items
        
        // Request
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        let reqHeaders = baseHeaders + environment.headers + headers
        reqHeaders.forEach {
            urlRequest.addValue($1, forHTTPHeaderField: $0)
        }
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
    
    var environment : Environment {
        return .staging
    }
}


private extension Dictionary {
    static func +(lhs: Dictionary, rhs: Dictionary?) -> Dictionary {
        if rhs == nil {
            return lhs
        } else {
            var dic = lhs
            rhs!.forEach { dic[$0] = $1 }
            return dic
        }
    }
}
extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any]
    }
}
