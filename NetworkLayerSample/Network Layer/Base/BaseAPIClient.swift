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
    
    static func performRequest<T:Decodable>(route: RouterRequestConvertible, decoder: JSONDecoder = JSONDecoder(), completion: ((_ result: Result<T>) -> Void)?) {
        
        sessionManager
            .request(route)
            .validate()
            .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                
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
                
            })
    }
}

