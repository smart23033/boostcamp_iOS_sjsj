//
//  ImageBoardAPI.swift
//  ImageBoard
//
//  Created by 김성준 on 2017. 7. 29..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

//MARK: Enum

enum StatusCode: Int {
    case defaultValue = 0
    case ok = 200
    case okCreated = 201
    case badRequest = 401
    case duplication = 406
    case badGateway = 502
}

enum ImageBoardError: Error {
    case invalidJSONData
}

enum SignUpError: Error {
    case duplication
}

enum LoginError: Error {
    case noUser
    case wrongPassword
}

enum ImageError: Error {
    case imageCreationError
}

enum UserResult {
    case success(User)
    case failure(Error)
}

enum ArticlesResult {
    case success([Article])
    case failure(Error)
}

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum SubURL: String {
    case board = ""
    case signUp = "user"
    case login = "login"
    case image = "image"
    
}

//MARK: URLs

struct ImageBoardAPI {
    private static let baseURLString = "https://ios-api.boostcamp.connect.or.kr/"
    
    private static func ImageBoardURL(_ subURL: SubURL) -> URL {
        
        let url = baseURLString + subURL.rawValue
        
        return (URLComponents(string: url)?.url)!
    }
    
    static func baseURL() -> URL {
        return ImageBoardURL(.board)
    }
    
    static func signUpURL() -> URL {
        return ImageBoardURL(.signUp)
    }
    
    static func loginURL() -> URL {
        return ImageBoardURL(.login)
    }
    
    static func imageURL() -> URL {
        return ImageBoardURL(.image)
    }
    
}

//MARK: Functions

extension ImageBoardAPI {
    static func user(from data: Data, code statusCode: StatusCode = .defaultValue) -> UserResult {
        
        let jsonDecoder = JSONDecoder()
        do {
            
            let user = try jsonDecoder.decode(User.self, from: data)
            return .success(user)
        }
        catch {
            
            let dataString = String(data: data, encoding: String.Encoding.utf8)!
//            print(dataString)
//            print(statusCode.rawValue)
            
            switch statusCode {
            case .duplication:
                return .failure(SignUpError.duplication)
            case .badRequest:
                if dataString.contains("wrong password") {
                    return .failure(LoginError.wrongPassword)
                }
                else if dataString.contains("no user"){
                    return .failure(LoginError.noUser)
                }
            default:
                break
            }
            return .failure(ImageBoardError.invalidJSONData)
            
        }
    }
    
    static func articles(from data: Data, code statusCode: StatusCode = .defaultValue) -> ArticlesResult {
        
        let jsonDecoder = JSONDecoder()
        do {
            // 현재 delete 절차에서는 에러로 던져짐. 배열로 response 안해줘서 디코딩 못함.
            let articles = try jsonDecoder.decode([Article].self, from: data)
            return .success(articles)
        }
        catch {
            print("statusCode : \(statusCode.rawValue)")
            switch statusCode {
             default:
                return .failure(ImageBoardError.invalidJSONData)
            }
        }
    }
    
}
