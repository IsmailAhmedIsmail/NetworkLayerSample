//
//  Endpoints.swift
//  NetworkLayerSample
//
//  Created by Ismail Ahmed on 2/3/19.
//  Copyright © 2019 Ismail Ahmed. All rights reserved.
//

protocol EndPoint {
    var subdomain : String { get }
    var path: String { get }
}

struct APIs {
    private static var basePath = ""
    
    enum Posts: EndPoint {
        case getAllPosts
        case getPost(id : Int)
        case addPost
        
        var subdomain : String {
            return "/posts"
        }
        
        
        var path: String {
            switch self {
            case .getAllPosts, .addPost:
                return APIs.basePath
            case .getPost(let id):
                return APIs.basePath + "/\(id)"
            }
        }
    }
    
    
    
}
