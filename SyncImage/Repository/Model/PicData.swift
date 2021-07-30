//
//  PicData.swift
//  SyncImage
//
//  Created by Lord Gift on 30/7/2564 BE.
//

import RealmSwift

class PicData: Object {
    
    @Persisted var path: String?
    @Persisted var isSynced: Bool = false
    
    convenience init(path: String) {
        self.init()
        self.path = path
    }
}
