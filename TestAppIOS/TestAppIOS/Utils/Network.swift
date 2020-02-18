//
//  Network.swift
//  TestAppIOS
//
//  Created by Admin on 18/02/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SystemConfiguration

struct JSON_Response: Codable{
    var Response: String?
    var Error:String?
}

public func request(text: String, completion: @escaping (Result<Data, Error>) -> Void){
    
//    omdb base url
    let base_url: String = "http://www.omdbapi.com/"
    // key provided by omdb for free api use
    let apikey: String = "653e019e"
    
    // Creation of the URL
    var url_component = URLComponents(string:base_url)
    let queryItems = [NSURLQueryItem(name: "apikey", value: apikey), NSURLQueryItem(name: "t", value: text)]
    url_component?.queryItems = queryItems as [URLQueryItem]
    let url = url_component?.url!
    
    // Creation of the Request
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    let session = URLSession.shared
    
//    Task start
    let task = session.dataTask(with: request) { (data, response, error) in
        
        DispatchQueue.main.async {
            
            guard let unwrappedResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.badResponse))
                return
            }
            switch unwrappedResponse.statusCode {
                
            case 200:
                if let unwrappedData = data {
                    let json_data = try! JSONDecoder().decode(JSON_Response.self, from: data!)
                    if json_data.Error == "Movie not found!"{
                        completion(.failure(NetworkError.movieNotFound))
                    }else{
                        completion(.success(unwrappedData))
                    }
                }
            default:
                completion(.failure(NetworkError.defaultError))
            }
            
            if let unwrappedError = error {
                completion(.failure(unwrappedError))
                return
            }
        }
    }
    
    task.resume()
}

enum NetworkError: Error{
    case badUrl
    case badResponse
    case defaultError
    case movieNotFound
}



public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}
