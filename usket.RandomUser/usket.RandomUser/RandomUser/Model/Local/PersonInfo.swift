//
//  PersonInfo.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/10/17.
//

import Foundation

typealias People = [PersonInfo]

struct PersonInfo: Equatable {
    let imageUrl: String
    let name: String
    let age: Int
    let country: String
    let city: String
    let email: String
    let dob: String
    let cell: String
}
