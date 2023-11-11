//
//  RandomUserAPI.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/10/17.
//

import Foundation
import RxSwift
import RxAlamofire

final class RandomUserService {
    
    static let shared = RandomUserService()
    
    func fetchRandomUsers(count: Int) -> Observable<PeopleDetail> {
        let baseUrl = RandomUserEndPoint.baseUrl
        let path = RandomUserEndPoint.multiple(count).path
        let url = baseUrl + path
        
        return RxAlamofire.requestJSON(.get, url)
            .map { (response, json) -> PeopleDetail in
                
                guard let data = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
                      let users = try? JSONDecoder().decode(Results.self, from: data)
                else {
                    throw RxAlamofire.RxAlamofireUnknownError
                }
                
                return users.results.map { $0.toPersonInfoDetail() }
            }
    }
}
