//
//  Limit.swift
//  SyncImage
//
//  Created by Lord Gift on 1/8/2564 BE.
//

import RealmSwift

class Limit: Object {
    
    @Persisted var png: Int?
    @Persisted var jpg: Int?
    @Persisted var heic: Int?
    
    convenience init(png: Int, jpg: Int, heic:Int) {
        self.init()
        self.png = png
        self.jpg = jpg
        self.heic = heic
    }
}

