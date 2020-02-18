//
//  Network.swift
//  TestAppIOS
//
//  Created by Admin on 18/02/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

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
                    completion(.success(unwrappedData))
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
}
