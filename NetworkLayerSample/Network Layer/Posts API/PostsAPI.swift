//
//  PostsAPIClient.swift
//  NetworkLayerSample
//
//  Created by Ismail Ahmed on 1/21/19.
//  Copyright © 2019 Ismail Ahmed. All rights reserved.
//

import Foundation
import Alamofire


class PostsAPIClient : BaseAPIClient {
    
    static func getAllPosts(completion: ((_ result: Result<[Post]>) -> Void)?) {
        performRequest(route: PostsAPIRouter.getAllPosts, completion: completion)
    }
    
    static func getPost(id : Int ,completion: ((_ result: Result<Post>) -> Void)? ) {
        performRequest(route: PostsAPIRouter.getPost(id: id), completion : completion)
    }
    
    static func addPost(post : Post , completion: ((_ result: Result<Post>) -> Void)? ) {
        performRequest(route: PostsAPIRouter.addPost(post: post), completion: completion)
    }
}
fileprivate enum PostsAPIRouter : RouterRequestConvertible {
    
    case getAllPosts
    case getPost(id : Int)
    case addPost(post: Post)
    
    var method: HTTPMethod {
        switch self {
        case .getAllPosts, .getPost:
            return .get
        case .addPost:
            return .post
        }
    }
    
    var endPoint: EndPoint {
        switch self {
        case .getAllPosts, .addPost:
            return APIs.Posts.getAllPosts
        case .getPost(let id):
            return APIs.Posts.getPost(id: id)
        }
    }
    
    var queryItems: QueryItems? {
        switch self {
        case .getPost(let id):
            return [
                Keys.profileID : "\(id)"
            ]
        case .addPost, .getAllPosts:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var parameters: Parameters? {
        switch self {
        case .addPost(let post):
            return post.dictionary
        case .getAllPosts, .getPost:
            return nil
        }
    }
    
    struct Keys {
        static let profileID = "profileID"
    }
}
