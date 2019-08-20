//
//  BaseAPIClient.swift
//  NetworkLayerSample
//
//  Created by Ismail Ahmed on 12/18/18.
//  Copyright © 2018 LinkDev. All rights reserved.
//
import Alamofire

class BaseAPIClient: NSObject {
    
    // in case there is SSL Pinning, uncomment next lines, remove the ":", and change domain (N.B: Do not forget to add the certificate file to the app and specify its target):
    
    private static let serverTrustPolicies: [String: ServerTrustPolicy] = [
//        "temp.domain.com": .pinPublicKeys(
//            publicKeys: ServerTrustPolicy.publicKeys(),
//            validateCertificateChain: false,
//            validateHost: true
        //        )
        :
    ]
    
    private static let sessionManager = SessionManager(
        
//        serverTrustPolicyManager: ServerTrustPolicyManager(
//            policies: serverTrustPolicies
//        )
    )
    
    
    private static func handleResponse<T:Decodable>(_ response: DataResponse<Any>, decoder: JSONDecoder = JSONDecoder(), completion: ((_ result: Result<T>) -> Void)?) {
        switch response.result {
        case .success:
            do {
                let variable = try decoder.decode(T.self, from: response.data!)
                completion?(.success(variable))
            } catch {
                completion?(.failure(error))
            }
            
        case .failure(let error):
            completion?(.failure(error))
        }
    }
    
    static func performRequest<T:Decodable>(route: RouterRequestConvertible, decoder: JSONDecoder = JSONDecoder(), completion: ((_ result: Result<T>) -> Void)?) {
        
        sessionManager
            .request(route)
            .validate()
            .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                handleResponse(response, decoder: decoder, completion: completion)
            })
    }
    
    static func performMultipartRequest<T:Decodable>(route:RouterMultiPartRequestConvertible, decoder: JSONDecoder = JSONDecoder(), completion: ((_ result: Result<T>) -> Void)?) {
        
            
            let baseRouteURLRequest = try! route.asURLRequest()
            
            sessionManager.upload(multipartFormData: { (multipartData) in
                route.parameters?.forEach({ (arg0) in
                    
                    let (key, value) = arg0
                    multipartData.append("\(value)".data(using: .utf8) ?? Data(), withName: key)
                })
                
                route.files?.forEach({ fileInfo in
                    
                    multipartData.append(fileInfo.filePathURL, withName: fileInfo.fieldName)
                })
                
            }, to: baseRouteURLRequest.url!) { (encodingResult) in
                
                switch encodingResult {
                
                case .success(let upload, _, _):
                    upload.validate().responseJSON(completionHandler: { (response: DataResponse<Any>) in
                        handleResponse(response, decoder: decoder, completion: completion)
                    })
                    
                case .failure(let error):
                    completion?(.failure(error))
                }
        }
    }
}

