//
//  AlbumTableViewController.swift
//  EchoBind-Spotify
//
//  Created by David Barkman on 4/11/21.
//

import UIKit

class AlbumTableViewController: UITableViewController {
    
    // MARK: - Variables

    let apiService = APIService()
    var albums = [Album]()
    lazy var spotifyService = SpotifyService()
    let albumsRefreshControl = UIRefreshControl()

    // MARK: - Main Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        let helpAlbum = Album(id: "0", name: "Please wait while we fetch your albums from:", artist: "Spotify.com", imageURL: "")
        albums.append(helpAlbum)

        let spotifyGreen = UIColor(red:(42.0 / 255.0), green:(183.0 / 255.0), blue:(89.0 / 255.0), alpha:1.0)
        view.backgroundColor = spotifyGreen
        navigationController?.navigationBar.backgroundColor = spotifyGreen
        title = "My Spotify Albums"
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAlbums), name: .sessionInitiated, object: nil)

        if let expirationDate = UserDefaults.standard.object(forKey: "expirationDate") as? Date {
            if Date() > expirationDate {
                let scope: SPTScope = [.userLibraryRead]
                spotifyService.sessionManager.initiateSession(with: scope, options: .default)
            } else {
                fetchAlbums()
            }
        }

        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero)

        tableView.refreshControl = albumsRefreshControl
        albumsRefreshControl.addTarget(self, action: #selector(refreshAlbums), for: .valueChanged)
    }
    
    @objc func refreshAlbums() {
        fetchAlbums()
    }

    @objc func fetchAlbums() {
        apiService.getAlbums(getAlbumsWithUrlClosure: { json, response in
            DispatchQueue.main.async {
                self.populateTable(json)
            }
        })
    }
    
    func populateTable(_ json: JSON) {
        albums.removeAll()
        let itemArray = json["items"].arrayValue
        if itemArray.count == 0 {
            let helpAlbum = Album(id: "0", name: "You currently have no albums in your library on:", artist: "Spotify.com", imageURL: "")
            albums.append(helpAlbum)
            tableView.reloadData()
        }
        for item in itemArray {
            let artistArray = item["album"]["artists"].arrayValue
            var artists = [String]()
            for artist in artistArray {
                if let artistName = artist["name"].rawString() {
                    artists.append(artistName)
                }
            }
            let artistsJoined = artists.joined(separator: ", ")
            if let albumId = item["album"]["id"].rawString(),
               let albumName = item["album"]["name"].rawString(),
               let imageURL = item["album"]["images"][2]["url"].rawString() {
                let album = Album(id: albumId, name: albumName, artist: artistsJoined, imageURL: imageURL)
                albums.append(album)
            }
        }
        tableView.reloadData()
        albumsRefreshControl.endRefreshing()
    }

    // MARK: - TableView Functions

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "album", for: indexPath)
        let album = albums[indexPath.row]
        cell.textLabel?.text = album.name
        cell.detailTextLabel?.text = album.artist
        cell.imageView?.image = UIImage(named: "record64")
        if let url = URL(string: album.imageURL) {
            apiService.downloadImage(from: url, downloadImageClosure: { data, response, error in
                if let imageData = data {
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: imageData)
                    }
                }
            })
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let album = albums[indexPath.row]
        showEnterAlbumNotesAlert(album: album)
    }
    
    // MARK: - Album Notes Functions

    func showEnterAlbumNotesAlert(album: Album) {
        let alert = UIAlertController(title: "Add your own notes for this album?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "add notes here"
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let notes = alert.textFields?.first?.text {
                self.saveAlbumNotes(album: album, notes: notes)
            }
        }))
        self.present(alert, animated: true)
    }
    
    func saveAlbumNotes(album: Album, notes: String) {
        apiService.saveAlbumNotes(album: album, notes: notes, saveAlbumNotesWithUrlClosure: { json, response in
            print("status code: \(response.statusCode)")
            print("json: \(json)")
        })
    }

}
