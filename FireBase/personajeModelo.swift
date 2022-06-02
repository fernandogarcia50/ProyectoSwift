//
//  personajeModelo.swift
//  FireBase
//
//  Created by Mac11 on 30/05/22.
//

import Foundation
struct PersonajeModelo: Decodable{
    let data : data?
}

struct data:Decodable {
    let results: [Results]
    
}

struct Results: Decodable {
    let name: String?
    let description: String?
    let thumbnail: Thumbnail?
}

struct Thumbnail: Decodable {
    let path: String?
    
}


