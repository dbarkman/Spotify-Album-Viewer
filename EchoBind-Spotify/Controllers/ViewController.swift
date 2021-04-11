//
//  ViewController.swift
//  EchoBind-Spotify
//
//  Created by David Barkman on 4/11/21.
//

import UIKit

class ViewController: UIViewController {

    let spotifyService = SpotifyService()

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: .sessionInitiated, object: nil)
        
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

    @objc func updateView() {
        //the purpose of this function is to run another fuction that is usually called from the main thread, but when called by messaging,
        //it runs on a background thread, so I use this function to run it on the main thread, as required
        DispatchQueue.main.async {
            self.updateViewBasedOnConnected()
        }
    }
    
    func updateViewBasedOnConnected() {
        if (spotifyService.sessionManager.session?.accessToken != nil) {
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
        if (spotifyService.sessionManager.session?.accessToken != nil) {
            spotifyService.sessionManager.renewSession()
        }
    }

    @objc func didTapConnect(_ button: UIButton) {
        let scope: SPTScope = [.userLibraryRead]
        spotifyService.sessionManager.initiateSession(with: scope, options: .default)
    }

}
