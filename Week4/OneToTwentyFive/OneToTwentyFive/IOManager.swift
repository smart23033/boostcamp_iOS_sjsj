//
//  IOManager.swift
//  OneToTwentyFive
//
//  Created by 김성준 on 2017. 7. 24..
//  Copyright © 2017년 김성준. All rights reserved.
//

import Foundation

class IOManager {
    let fileManager = FileManager.default
    let homeDirectory = NSHomeDirectory()
    var data: Data?
    
    func readFile(fileName: String) -> Data? {
        if self.fileManager.fileExists(atPath: homeDirectory + "/" + fileName) {
            data = self.fileManager.contents(atPath: homeDirectory + "/" + fileName)
        }
        else {
            print("file doesn`t exist")
        }
        return data
    }
    
    func writeFile(fileName: String, result: String) {
//        do {
//            try fileManager.removeItem(atPath: homeDirectory + "/" + fileName)
//        }
//        catch {
//            
//        }
        guard self.fileManager.fileExists(atPath: homeDirectory + "/" + fileName) == true else {
            fileManager.createFile(atPath: homeDirectory + "/" + fileName, contents: nil, attributes: nil)
            return
        }
        
        if let file = FileHandle(forWritingAtPath: homeDirectory + "/" + fileName) {
            let data = result.data(using: String.Encoding.utf8)
            file.seekToEndOfFile()
            file.write(data!)
            file.closeFile()
        }
        else {
            print("fail to write")
        }
    }
    
}
