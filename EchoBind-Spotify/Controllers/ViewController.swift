//
//  ViewController.swift
//  EchoBind-Spotify
//
//  Created by David Barkman on 4/11/21.
//

import UIKit

class ViewController: UIViewController, SPTSessionManagerDelegate {

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

    // MARK: - Subviews

    private lazy var connectLabel: UILabel = {
        let label = UILabel()
        label.text = "Connect your Spotify account"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var connectButton = Button(title: "CONNECT")
    private lazy var disconnectButton = Button(title: "DISCONNECT")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(connectLabel)
        view.addSubview(connectButton)
        view.addSubview(disconnectButton)

        let constant: CGFloat = 16.0

        connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        disconnectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        disconnectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true

        connectLabel.centerXAnchor.constraint(equalTo: connectButton.centerXAnchor).isActive = true
        connectLabel.bottomAnchor.constraint(equalTo: connectButton.topAnchor, constant: -constant).isActive = true

        connectButton.sizeToFit()
        disconnectButton.sizeToFit()

        connectButton.addTarget(self, action: #selector(didTapConnect(_:)), for: .touchUpInside)
        disconnectButton.addTarget(self, action: #selector(didTapDisconnect(_:)), for: .touchUpInside)

        updateViewBasedOnConnected()
    }

    func updateViewBasedOnConnected() {
        if (sessionManager.session?.accessToken != nil) {
            connectButton.isHidden = true
            disconnectButton.isHidden = false
            connectLabel.isHidden = true
        } else {
            disconnectButton.isHidden = true
            connectButton.isHidden = false
            connectLabel.isHidden = false
        }
    }

    // MARK: - Actions

    @objc func didTapDisconnect(_ button: UIButton) {
        if (sessionManager.session?.accessToken != nil) {
            sessionManager.renewSession()
        }
    }

    @objc func didTapConnect(_ button: UIButton) {
        let scope: SPTScope = [.userLibraryRead]
        sessionManager.initiateSession(with: scope, options: .default)
    }

    // MARK: - SPTSessionManagerDelegate

    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("Authorization Failed")
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("Session Renewed")
    }

    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        UserDefaults.standard.set(session.accessToken, forKey: "accessToken")
        print("Auth connected! AccessToken: \(session.accessToken)")
//        let apiService = APIService()
//        apiService.getAlbums(getAlbumsWithUrlClosure: { json, response in
//            print(response)
//            print(json)
//        })
//        DispatchQueue.main.async {
//            self.updateViewBasedOnConnected()
//        }
    }

}
