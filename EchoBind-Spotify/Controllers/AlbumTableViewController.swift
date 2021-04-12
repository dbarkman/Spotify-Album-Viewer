//
//  AlbumTableViewController.swift
//  EchoBind-Spotify
//
//  Created by David Barkman on 4/11/21.
//

import UIKit

class AlbumTableViewController: UITableViewController {
    
    let apiService = APIService()
    var albums = [Album]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let apiService = APIService()
        apiService.getAlbums(getAlbumsWithUrlClosure: { json, response in
            DispatchQueue.main.async {
                self.populateTable(json)
            }
        })
    }
    
    func populateTable(_ json: JSON) {
        let itemArray = json["items"].arrayValue
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
                tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

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
        let apiService = APIService()
        apiService.saveAlbumNotes(album: album, notes: notes, saveAlbumNotesWithUrlClosure: { json, response in
            print("response: \(response)")
            print("json: \(json)")
        })
    }

}
