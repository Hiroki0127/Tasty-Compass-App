//
//  YelpAPIServicie.swift
//  Tasty Compass
//



import Foundation
import CoreLocation
import Combine


//let apiKey = "0wCG9Xv3pATQXcuE6_whAa2ctcLyEYnKWBiFKQFE65mfkxovFL6npf2plC9nCAbQwqA0tVk-GWFWn4liU_lIFOt67oo0Pj4ULeHXO7rl9tfyRc89ra_OqTng3O-RZXYx"


struct YelpAPIService{
    //search term, user location, and the 3rd param is category when selected (optional)
    var search: (String, CLLocation, String?) -> AnyPublisher<[Business], Never> // the array is the output list
    //var loadData: (CLLocation)
}

extension YelpAPIService {
    static let live = YelpAPIService { term, location, cat in
        var urlComponents = URLComponents(string: "https://api.yelp.com")!
        urlComponents.path = "/v3/businesses/search"
        urlComponents.queryItems = [
            .init(name: "term", value: term),
            .init(name: "longitude", value: String(location.coordinate.longitude)),
            .init(name: "latitude", value: String(location.coordinate.latitude)),
            .init(name: "categories", value: cat ?? "restaurants")
        ]
        let url = urlComponents.url!
        var request = URLRequest(url:url)
        request.addValue("Bearer \("0wCG9Xv3pATQXcuE6_whAa2ctcLyEYnKWBiFKQFE65mfkxovFL6npf2plC9nCAbQwqA0tVk-GWFWn4liU_lIFOt67oo0Pj4ULeHXO7rl9tfyRc89ra_OqTng3O-RZXYx")", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        // URL request
        return URLSession.shared.dataTaskPublisher(for: request)//create a request
            .map(\.data) //extract data type
            .decode(type: SearchResult.self, decoder: JSONDecoder())
            .map(\.businesses)
            .replaceError(with:[])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}





struct SearchResult:Codable {
    let businesses: [Business]
    
}


struct Business:Codable {
    
    let rating: Double?
    let price, phone, id, alias: String?
    let isClosed: Bool?
    let categories: [Category]?
    let reviewCount: Double?
    let name: String?
    let url: String?
    let coordinates: Coordinates?
    let imageURL: String?
    let location: Location?
    let distance: Double?
    let transactions: [String]?
    
    enum CodingKeys: String, CodingKey {
        case rating, price, phone, id, alias
        case isClosed = "is_closed"
        case categories
        case reviewCount = "review_count"
        case name, url, coordinates
        case imageURL = "image_url"
        case location, distance, transactions
    }
}

struct Category:Codable {
    let alias, title: String?
}


struct Coordinates: Codable {
    let latitude, longitude: Double?
}


struct Location:Codable {
    let city, country, address2, address3: String?
    let state, address1, zipCode:String?
    
    enum CodingKeys: String, CodingKey {
        case city, country, address2, address3, state, address1
        case zipCode = "zip_code"
    }
}




