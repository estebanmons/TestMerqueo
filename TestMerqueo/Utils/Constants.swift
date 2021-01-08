//
//  Constants.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 5/01/21.
//

import Foundation

struct Constants {
    
    static let baseUrl = "https://api.themoviedb.org/3/"
    static let apiKey = "674d230726a9141a5e4cb7090e79aa8f"
    static let baseImageUrl = "https://image.tmdb.org/t/p/w500"
    
    static let accept = "Accept"
    static let warning = "Warning"
    
    static let notHomePage = "Web page not available."
    
}

enum RequestError: Error {
    case unknownError
    case connectionError
    case authorizationError
    case serverError
}
