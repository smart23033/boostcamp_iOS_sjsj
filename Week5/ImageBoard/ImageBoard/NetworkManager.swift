//
//  UserStore.swift
//  ImageBoard
//
//  Created by 김성준 on 2017. 7. 29..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class NetworkManager {
    
    //MARK: Properties
    
    let session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    let jsonEncoder = JSONEncoder()
    static let shared = NetworkManager()
    
    //MARK: Initializer
    
    private init() {
        
    }
    
    //MARK: SignUp Functions
    
    func fetchSignUpInfo(user: User, _ completion: @escaping (UserResult) -> Void) {
        do{
            
            let data = try jsonEncoder.encode(user)
            let url = ImageBoardAPI.signUpURL()
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = data
            
            let task = session.dataTask(with: request) {
                (data, response, error) -> Void in
                
                if let httpResponse = response as? HTTPURLResponse {
                    let result = self.processSignUpRequest(statusCode: StatusCode(rawValue: httpResponse.statusCode), data: data, error: error)
                    
                    completion(result)
                }
            }
            task.resume()
        }
        catch {
            print("userObject encoding error")
        }
        
    }
    
    func processSignUpRequest(statusCode: StatusCode?, data: Data?, error: Error?) -> UserResult {
        guard let jsonData = data,
            let code = statusCode else {
                return .failure(error!)
        }
        
        return ImageBoardAPI.user(from: jsonData, code: code)
    }
    
    //MARK: Login Functions
    
    func fetchLoginInfo(user: User, _ completion: @escaping (UserResult) -> Void) {
        
        do{
            
            let data = try jsonEncoder.encode(user)
            let url = ImageBoardAPI.loginURL()
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = data
            
            let task = session.dataTask(with: request) {
                (data, response, error) -> Void in
                
                if let httpResponse = response as? HTTPURLResponse {
                     let result = self.processLoginRequest(statusCode: StatusCode(rawValue: httpResponse.statusCode), data: data, error: error)
                    
                    completion(result)
                }
                
            }
            task.resume()
            
        }
        catch {
            print("userObject encoding error")
        }
        
    }
    
    func processLoginRequest(statusCode: StatusCode?, data: Data?, error: Error?) -> UserResult {
        
        guard let jsonData = data,
            let code = statusCode else {
                return .failure(error!)
        }
        
        return ImageBoardAPI.user(from: jsonData, code: code)
        
    }
    
    //MARK: TableView Functions
    
    func fetchBoardInfo(_ completion: @escaping (ArticlesResult) -> Void) {
        
        let url = ImageBoardAPI.baseURL()
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processArticlesRequest(data: data, error: error)
            
            completion(result)
        }
        
        task.resume()
    }
    
    func processArticlesRequest(data: Data?, error: Error?) -> ArticlesResult {
        
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return ImageBoardAPI.articles(from: jsonData)
        
    }
    
    //MARK: TableView Image Functions
    
    func fetchThumbImage(from article: Article, completion: @escaping (ImageResult) -> Void) {
        
        if let thumbImage = article.thumbImage {
            completion(.success(thumbImage))
            return
        }
        
        let thumbImageURL = ImageBoardAPI.baseURL().appendingPathComponent(article.thumb_image_url)
        let request = URLRequest(url: thumbImageURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processThumbImageRequest(data: data, error: error)
            
            if case let .success(thumbImage) = result {
                article.thumbImage = thumbImage
            }
            
            completion(result)
        }
        
        task.resume()
    }
    
    func processThumbImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard let imageData = data, let thumbImage = UIImage(data: imageData) else {
            if data == nil {
                return .failure(error!)
            }
            else {
                return .failure(ImageError.imageCreationError)
            }
        }
        return .success(thumbImage)
    }
    
    //MARK: DetailView Image Functions
    
    func fetchImage(from article: Article, completion: @escaping (ImageResult) -> Void) {
        
        if let image = article.image {
            completion(.success(image))
            return
        }
        
        let imageURL = ImageBoardAPI.baseURL().appendingPathComponent(article.image_url!)
        let request = URLRequest(url: imageURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .success(image) = result {
                article.image = image
            }
            
            completion(result)
        }
        
        task.resume()
    }
    
    func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard let imageData = data, let image = UIImage(data: imageData) else {
            if data == nil {
                return .failure(error!)
            }
            else {
                return .failure(ImageError.imageCreationError)
            }
        }
        return .success(image)
    }
    
    //MARK: Upload Functions
    
    func fetchUploadInfo(title image_title: String, desc image_desc: String, image image_data: UIImage, completion: @escaping (ArticlesResult) -> Void) {
        
        let url = ImageBoardAPI.imageURL()
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createRequestBodyWith(title: image_title, desc: image_desc, image: image_data, boundary: boundary)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                let result = self.processUploadRequest(statusCode: StatusCode(rawValue: httpResponse.statusCode), data: data, error: error)
                
                completion(result)
                
            }
        }
        
        task.resume()
    }
    
    func processUploadRequest(statusCode: StatusCode?, data: Data?, error: Error?) -> ArticlesResult {
        
        guard let jsonData = data,
            let code = statusCode else {
                return .failure(error!)
        }
        
        return ImageBoardAPI.articles(from: jsonData, code: code)
        
    }
    
    func createRequestBodyWith(title: String, desc: String, image: UIImage, boundary:String) -> Data {
        
        let body = NSMutableData()
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"image_title\"\r\n\r\n")
        body.appendString(string: "\(title)\r\n")
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"image_desc\"\r\n\r\n")
        body.appendString(string: "\(desc)\r\n")
        
        body.appendString(string: "--\(boundary)\r\n")
        
        let mimetype = "image/jpg"
        
        let defFileName = title.appending("jpg")
        
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        
        body.appendString(string: "Content-Disposition: form-data; name=\"image_data\"; filename=\"\(defFileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData!)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body as Data
    }
    
    
    //MARK: Delete Functions
    
    func fetchDeleteInfo(from article:Article, completion: @escaping (ArticlesResult) -> Void) {
        
        let url = ImageBoardAPI.imageURL().appendingPathComponent(article._id)
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                let result = self.processDeleteRequest(statusCode: StatusCode(rawValue: httpResponse.statusCode), data: data, error: error)
                
                completion(result)
            }
        }
        task.resume()
    }
    
    func processDeleteRequest(statusCode: StatusCode?, data: Data?, error: Error?) -> ArticlesResult {
        
        guard let jsonData = data,
            let code = statusCode else {
                return .failure(error!)
        }
        
        return ImageBoardAPI.articles(from: jsonData, code: code)
        
    }
    
}
