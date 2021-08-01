//
//  PathUtil.swift
//  SyncImage
//
//  Created by Lord Gift on 30/7/2564 BE.
//

import Foundation

class Util {
    class func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
}
