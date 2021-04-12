//
//  Network.swift
//  EchoBind-Spotify
//
//  Created by David Barkman on 4/11/21.
//

import Foundation

struct Network {
    
    static func callAPI(request: URLRequest, callAPIClosure: @escaping (JSON, HTTPURLResponse) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    let json = JSON(parseJSON: dataString)
                    if let response = response as? HTTPURLResponse {
                        callAPIClosure(json, response)
                    }
                } else {
                    print("Client Error")
                }
            }
        }
        task.resume()
    }
    
    static func getImage(from url: URL, getImageClosure: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: getImageClosure).resume()
    }
    
}
