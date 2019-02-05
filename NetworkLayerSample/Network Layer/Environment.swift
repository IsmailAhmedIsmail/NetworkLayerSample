//
//  Environment.swift
//  NetworkLayerSample
//
//  Created by Ismail Ahmed on 1/27/19.
//  Copyright © 2019 Ismail Ahmed. All rights reserved.
//

import Foundation

enum Environment {
    
    case staging
    case production
    
    var scheme: String {
        switch self {
        case .staging:      return "http"
        case .production:   return "https"
        }
    }
    
    var host: String {
        switch self {
        case .staging:      return "jsonplaceholder.typicode.com"
        case .production:   return "www.production.com"
        }
    }
    
    var port: Int? {
        switch self {
        default:            return nil
        }
    }
    
    var components : URLComponents {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.port = self.port
        return components
    }
    
    //additonal headers specified for the environment only
    var headers : [String : String]? {
        switch self {
        case .staging:      return nil
        case .production:   return ["Authentication": "ProductionAPIKey"]
        }
    }
    
    //used for webviews as example
    var baseURL : String {
        switch self {
        case .staging:      return "http://jsonplaceholder.typicode.com"
        case .production:   return "www.production.com"
        }
    }
    
}
