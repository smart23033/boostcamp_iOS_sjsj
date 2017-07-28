//
//  FlickrAPI.swift
//  Photorama
//
//  Created by 김성준 on 2017. 7. 28..
//  Copyright © 2017년 김성준. All rights reserved.
//

import Foundation

enum FlickrError: Error {
    case invalidJSONData
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

enum Method: String {
    case recentPhotos = "flickr.photos.getRecent"
}

struct FlickrAPI {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIkey = "b3d536ba991852e834d4ed2db8fd01a3"
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static func flickrURL(method: Method, parameters: [String:String]?) -> URL {
        
        var components = URLComponents(string: baseURLString)
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback":"1",
            "api_key": APIkey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components?.queryItems = queryItems
        
        return (components?.url)!
    }
    
    static func recentPhotosURL() -> URL {
        return flickrURL(method: .recentPhotos, parameters: ["extras":"url_h,date_taken"])
    }
    
    private static func photoFromJSONObject(json: [String:AnyObject]) -> Photo? {
        guard let photoID = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString) else {
                return nil
        }
        return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
    }
    
    static func photosFromJSONData(data: Data) -> PhotosResult {
        do {
            let jsonObject: AnyObject =
                try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            
            guard let jsonDictionary = jsonObject as? [NSObject:AnyObject],
            let photos = jsonDictionary["photos" as NSObject] as? [String:AnyObject],
            let photosArray = photos["photo"] as? [[String:AnyObject]]else {
                return .failure(FlickrError.invalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photoFromJSONObject(json: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.count == 0 && photosArray.count > 0 {
                return .failure(FlickrError.invalidJSONData)
            }
            
            return .success(finalPhotos)
        }
        catch {
            return .failure(error)
        }
        
    }
    
}
