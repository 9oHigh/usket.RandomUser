//
//  RandomUser.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/10/17.
//

import Foundation

enum RandomUserEndPoint {
    
    case multiple(Int)

    var path: String {
        switch self {
        case .multiple(let count):
            return "?results=\(count)"
        }
    }
}

extension RandomUserEndPoint {
    static let baseUrl: String  = "https://randomuser.me/api/"
}
