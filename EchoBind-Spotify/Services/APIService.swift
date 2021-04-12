//
//  APIService.swift
//  EchoBind-Spotify
//
//  Created by David Barkman on 4/11/21.
//

import Foundation

struct APIService {
    
//    func refreshToken() {
//        print("refreshing token")
//        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else { return }
//        print("refreshToken: \(refreshToken)")
//        let jsonRequestBody = [
//            "refresh_token": refreshToken
//        ]
//        let jsonRequest = try! JSONSerialization.data(withJSONObject: jsonRequestBody, options: [])
//        guard let url = URL(string: "https://api.spotify.com/v1/refresh") else { return }
//        print("url: \(url.description)")
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonRequest
//        Network.callAPI(request: request, callAPIClosure: { json, response in
//        })
//    }

    func getAlbums(getAlbumsWithUrlClosure: @escaping (JSON, HTTPURLResponse) -> Void) {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        guard let url = URL(string: "https://api.spotify.com/v1/me/albums?market=US&limit=50") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        Network.callAPI(request: request, callAPIClosure: { json, response in
            getAlbumsWithUrlClosure(json, response)
        })
    }
    
    func downloadImage(from url: URL, downloadImageClosure: @escaping (Data?, URLResponse?, Error?) -> Void) {
        Network.getImage(from: url, getImageClosure: { data, response, error in
            guard let data = data, error == nil else { return }
            downloadImageClosure(data, response, error)
        })
    }
    
    func saveAlbumNotes(album: Album, notes: String, saveAlbumNotesWithUrlClosure: @escaping (JSON, HTTPURLResponse) -> Void) {
        let jsonRequestBody = [
            "albumId": album.id,
            "note": notes
        ]
        let jsonRequest = try! JSONSerialization.data(withJSONObject: jsonRequestBody, options: [])
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/comments") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonRequest
        Network.callAPI(request: request, callAPIClosure: { json, response in
            saveAlbumNotesWithUrlClosure(json, response)
        })
    }
}
