//
//  EchoBind_SpotifyTests.swift
//  EchoBind-SpotifyTests
//
//  Created by David Barkman on 4/11/21.
//

import XCTest
@testable import EchoBind_Spotify

class EchoBind_SpotifyTests: XCTestCase {

    let apiService = APIService()
    
    func testGetAlbumsAPICallStatusCode() throws {
        apiService.getAlbums(getAlbumsWithUrlClosure: { json, response in
            XCTAssertEqual(
                response.statusCode,
                200,
                "Response code should be 200."
            )
        })
    }

    func testGetAlbumsAPICallData() throws {
        apiService.getAlbums(getAlbumsWithUrlClosure: { json, response in
            if let href = json["href"].rawString() {
                XCTAssertEqual(href, "https://api.spotify.com/v1/me/albums?market=US&limit=50")
            }
        })
    }

    func testSaveAlbumNotesAPICallStatusCode() throws {
        let album = Album(id: "101", name: "Album", artist: "Artist", imageURL: "")
        apiService.saveAlbumNotes(album: album, notes: "some notes", saveAlbumNotesWithUrlClosure: { json, response in
            XCTAssertEqual(
                response.statusCode,
                201,
                "Response code should be 201."
            )
        })
    }

    func testSaveAlbumNotesAPICallData() throws {
        let album = Album(id: "101", name: "Album", artist: "Artist", imageURL: "")
        apiService.saveAlbumNotes(album: album, notes: "some notes", saveAlbumNotesWithUrlClosure: { json, response in
            if let note = json["note"].rawString() {
                XCTAssertEqual(note, "some notes")
            }
            if let albumId = json["albumId"].rawString() {
                XCTAssertEqual(albumId, "101")
            }
        })
    }
    
    func testNetworkCallAPIStatusCode() throws {
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!)
        request.httpMethod = "GET"
        Network.callAPI(request: request, callAPIClosure: { json, response in
            XCTAssertEqual(
                response.statusCode,
                200,
                "Response code should be 200."
            )
        })
    }

}
