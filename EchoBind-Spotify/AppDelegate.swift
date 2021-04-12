//
//  AppDelegate.swift
//  EchoBind-Spotify
//
//  Created by David Barkman on 4/11/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var spotifyService = SpotifyService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if UserDefaults.standard.object(forKey: "expirationDate") == nil {
            UserDefaults.standard.set(Date(), forKey: "expirationDate")
        }
        
        return true
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        spotifyService.sessionManager.application(application, open: url, options: options)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }
}
