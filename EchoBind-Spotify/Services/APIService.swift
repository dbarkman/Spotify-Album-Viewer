//
//  APIService.swift
//  EchoBind-Spotify
//
//  Created by David Barkman on 4/11/21.
//

import Foundation

struct APIService {
    
    func getAlbums(getAlbumsWithUrlClosure: @escaping (JSON, HTTPURLResponse) -> Void) {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        guard let url = URL(string: "https://api.spotify.com/v1/me/albums?market=US")  else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
//        request.setValue("Bearer BQD50lOwGHDEJiV-9F3UJtAFDoOrqZE5ilJaRQ0rRaSZRqwu35bRoouio-yv5XSJYmrlF2Owswp-g8RRFcab35l7necBpRT1hPriq9rJFXF_ZdPd-4xTPcy6f22sFKbw59BhGrwY--DAQ-Mkylj5i2EoZ7c", forHTTPHeaderField: "Authorization")
        Network.callAPI(request: request, callAPIClosure: { json, response in
            getAlbumsWithUrlClosure(json, response)
        })
    }
}
