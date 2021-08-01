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
        let realmConfig = Realm.Configuration(schemaVersion: 3)
        realm = try! Realm(configuration: realmConfig)
    }
    
    func getAllPicData() -> Results<PicData>? {
        return realm?.objects(PicData.self)
    }
    
    func getPicData(index: Int) -> PicData? {
        return realm?.objects(PicData.self)[index]
    }
    
    func getPicData(isSynced: Bool) -> [PicData]? {
        if isSynced {
            return realm?.objects(PicData.self).filter("timestamp != nil").toArray(ofType: PicData.self)
        } else {
            return realm?.objects(PicData.self).filter("timestamp == nil").toArray(ofType: PicData.self)
        }
    }
    
    func savePicData(picData: PicData) {
        try! self.realm?.write {
            self.realm?.add(picData)
        }
    }
    
    func updatePicData(picData: PicData) {
        let modifyingPicData = realm?.objects(PicData.self).filter("name = %@", picData.name!).first
        try! self.realm?.write {
            modifyingPicData?.timestamp = picData.timestamp
//        try! self.realm?.write {
//            self.realm?.add(modifyingPicData!, update: .modified)
        }
    }
    
    
    func getLimit() -> Limit? {
        return realm?.objects(Limit.self).first
    }
    
    func setLimit(limit: Limit) {
        let modifyingLimit = realm?.objects(Limit.self).first
        
        try! self.realm?.write {
            if modifyingLimit != nil {
                modifyingLimit?.png = limit.png
                modifyingLimit?.jpg = limit.jpg
                modifyingLimit?.heic = limit.heic
            } else {
                self.realm?.add(limit)
            }
        }
    }
    
}
