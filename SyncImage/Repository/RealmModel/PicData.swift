//
//  PicData.swift
//  SyncImage
//
//  Created by Lord Gift on 30/7/2564 BE.
//

import RealmSwift

class PicData: Object {
    
    @Persisted var name: String?
    @Persisted var timestamp: String?
    
    convenience init(name: String, timestamp: String?) {
        self.init()
        self.name = name
        self.timestamp = timestamp
    }
}
