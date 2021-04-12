//
//  SpotifyService.swift
//  EchoBind-Spotify
//
//  Created by David Barkman on 4/11/21.
//

import Foundation

class SpotifyService: NSObject, SPTSessionManagerDelegate {
    
    private let SpotifyClientID = "737bab0a173d4b299a0180156c8ac780"
    private let SpotifyRedirectURI = URL(string: "EchoBind-Spotify://spotify-login-callback")!

    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        configuration.tokenSwapURL = URL(string: "https://echobindspotifyalbumviewer.herokuapp.com/api/token")
        configuration.tokenRefreshURL = URL(string: "https://echobindspotifyalbumviewer.herokuapp.com/api/refresh_token")
        return configuration
    }()

    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()

    // MARK: - SPTSessionManagerDelegate

    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("Authorization Failed: \(error)")
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("Session Renewed")
    }

    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        UserDefaults.standard.set(session.accessToken, forKey: "accessToken")
        UserDefaults.standard.set(session.refreshToken, forKey: "refreshToken")
        UserDefaults.standard.set(session.expirationDate, forKey: "expirationDate")
        print("Auth connected! AccessToken: \(session.accessToken)")
        print("Token expires: \(session.expirationDate)")
        NotificationCenter.default.post(name: .sessionInitiated, object: nil)
//        let apiService = APIService()
//        apiService.getAlbums(getAlbumsWithUrlClosure: { json, response in
//            print("response: \(response)")
//            print("json: \(json)")
//        })
    }

}
