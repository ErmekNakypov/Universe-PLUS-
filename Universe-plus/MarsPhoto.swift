//
//  MarsPhoto.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 17/12/24.
//

struct MarsPhoto: Codable, Identifiable {
    let id: Int
    let imgSrc: String
    let rover: Rover
    let camera: Camera
    
    enum CodingKeys: String, CodingKey {
        case id
        case imgSrc = "img_src"
        case rover
        case camera
    }
}

struct Rover: Codable {
    let name: String
}

struct Camera: Codable {
    let name: String
    let fullName: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
    }
}
