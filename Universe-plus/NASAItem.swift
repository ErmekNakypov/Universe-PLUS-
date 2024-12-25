//
//  NASAItem.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 19/12/24.
//

import SwiftUI

struct NASAItem: Identifiable {
    let id: String
    let title: String
    let description: String
    let mediaType: String
    let thumbnailUrl: String
    let collectionUrl: String 

    init?(json: [String: Any]) {
        guard
            let data = (json["data"] as? [[String: Any]])?.first,
            let id = data["nasa_id"] as? String,
            let title = data["title"] as? String,
            let mediaType = data["media_type"] as? String,
            let links = json["links"] as? [[String: Any]],
            let thumbnailUrl = links.first?["href"] as? String,
            let collectionUrl = json["href"] as? String
        else {
            return nil
        }

        self.id = id
        self.title = title
        self.description = data["description"] as? String ?? "No description available."
        self.mediaType = mediaType
        self.thumbnailUrl = thumbnailUrl
        self.collectionUrl = collectionUrl
    }
}

