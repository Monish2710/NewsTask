//
//  ModelList.swift
//  News App
//
//  Created by Monish Kumar on 28/06/23.
//

import Foundation
import UIKit

// MARK: - NewsList

struct NewsList: Codable {
    let response: Response

    enum CodingKeys: String, CodingKey {
        case response
    }
}

// MARK: - Response

struct Response: Codable {
    let docs: [Doc]
}

// MARK: - Doc

struct Doc: Codable {
    let abstract: String
    let webURL: String
    let snippet, leadParagraph, printPage: String
    let headline: Headline
    let byline: Byline
    let id: String
    let wordCount: Int
    let uri: String
    let pub_date: String?
    let printSection: String?

    enum CodingKeys: String, CodingKey {
        case abstract
        case webURL = "web_url"
        case snippet
        case leadParagraph = "lead_paragraph"
        case printPage = "print_page"
        case headline
        case byline
        case id = "_id"
        case wordCount = "word_count"
        case uri
        case pub_date
        case printSection = "print_section"
    }
}

// MARK: - Byline

struct Byline: Codable {
    let original: String?
    let person: [Person]
}

// MARK: - Person

struct Person: Codable {
    let firstname, middlename, lastname: String?
    let organization: String
    let rank: Int
}

// MARK: - Headline

struct Headline: Codable {
    let main: String
    let kicker: String?
    let printHeadline: String

    enum CodingKeys: String, CodingKey {
        case main, kicker
        case printHeadline = "print_headline"
    }
}

// MARK: - Trending

struct Trending: Codable {
    let status, copyright: String
    let numResults: Int
    let results: [TendingResponse]

    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case results
    }
}

// MARK: - Result

struct TendingResponse: Codable {
    let uri: String
    let url: String
    let id, assetID: Int
    let publishedDate, updated, section: String
    let nytdsection, adxKeywords: String
    let byline: String
    let title, abstract: String
    let desFacet, orgFacet, perFacet, geoFacet: [String]
    let media: [Media]
    let etaID: Int

    enum CodingKeys: String, CodingKey {
        case uri, url, id
        case assetID = "asset_id"
        case publishedDate = "published_date"
        case updated, section, nytdsection
        case adxKeywords = "adx_keywords"
        case byline, title, abstract
        case desFacet = "des_facet"
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case geoFacet = "geo_facet"
        case media
        case etaID = "eta_id"
    }
}

// MARK: - Media

struct Media: Codable {
    let approvedForSyndication: Int
    let mediaMetadata: [MediaMetadatum]

    enum CodingKeys: String, CodingKey {
        case approvedForSyndication = "approved_for_syndication"
        case mediaMetadata = "media-metadata"
    }
}

// MARK: - MediaMetadatum

struct MediaMetadatum: Codable {
    let url: String
    let height, width: Int
}
