//
//  MovieCreditsResponse.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 6/01/21.
//

import Foundation

// MARK: - Welcome
struct MovieCreditsResponse: Codable, Equatable {
    
    let id: Int?
    let cast, crew: [Cast]?
    
    static func == (lhs: MovieCreditsResponse, rhs: MovieCreditsResponse) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Cast
struct Cast: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment: String?
    let name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castID: Int?
    let character, creditID: String?
    let order: Int?
    let department: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}
