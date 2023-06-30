//
//  NewsViewModel.swift
//  News App
//
//  Created by Monish Kumar on 29/06/23.
//

import Alamofire
import Foundation
import UIKit

class NewsViewModel: NSObject {
    typealias FetchCompletion = (Result<NewsList, Error>) -> Void
    let apiKey = "x2gTwp3LfLER5oxUEqYwYSGHTNCWAx9C"
    var totalPage = 50

    fileprivate func fetchAPI(_ page: Int, _ completion: @escaping FetchCompletion) {
        let urlString = "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=unitedstates&api-key=\(apiKey)&page=\(page)"
        AF.request(urlString).response { response in
            if let data = response.data {
                do {
                    let userResponse = try JSONDecoder().decode(NewsList.self, from: data)
                    completion(.success(userResponse))
                } catch let err {
                    completion(.failure(err))
                }
            }
        }
    }

    func fetchNews(completion: @escaping FetchCompletion) {
        fetchAPI(0, completion)
    }

    func fetchMoreNews(_ pageNumber: Int, completion: @escaping FetchCompletion) {
        fetchAPI(pageNumber, completion)
    }

    func fetchTrendingAPI(_ completion: @escaping (Result<Trending, Error>) -> Void) {
        let urlString = "https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json?api-key=x2gTwp3LfLER5oxUEqYwYSGHTNCWAx9C"
        AF.request(urlString).response { response in
            if let data = response.data {
                do {
                    let userResponse = try JSONDecoder().decode(Trending.self, from: data)
                    completion(.success(userResponse))
                } catch let err {
                    completion(.failure(err))
                }
            }
        }
    }
}
