//
//  Local.swift
//  SyncImage
//
//  Created by Lord Gift on 30/7/2564 BE.
//

import RealmSwift

class Local {
    
    var realm:Realm?
    
    init() {
        realm = try! Realm()
    }
    
    func getAllPicData() -> Results<PicData>? {
        return realm?.objects(PicData.self)
    }
    
    func getPicData(index: Int) -> PicData? {
        return realm?.objects(PicData.self)[index]
    }
    
    func savePicData(picData: PicData) {
        try! self.realm?.write {
            self.realm?.add(picData)
        }
    }
}
