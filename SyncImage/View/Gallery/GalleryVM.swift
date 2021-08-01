//
//  GalleryVM.swift
//  SyncImage
//
//  Created by LordGift on 27/7/2564 BE.
//

import Foundation
import UIKit

class GalleryVM {
    
    var countPng:Int?
    var countJpg:Int?
    var countHeic:Int?
    var limit: Limit?
    
    private var local = Local()
    private var remote = Remote()
    
    init() {
        countAvailableAndLimit()
    }
    
    func countAvailableAndLimit() {
        self.countPng = self.countPicData(ext: "png")
        self.countJpg = self.countPicData(ext: "jpg")
        self.countHeic = self.countPicData(ext: "heic")
        self.limit = self.getLimit()
    }
    
    func countPicData() -> Int {
        return local.getAllPicData()?.count ?? 0
    }

    func countPicData(ext:String) -> Int {
        return local.getPicDataNoSync(ext: ext)?.count ?? 0
    }
    
    func getPicData(index: Int) -> PicData? {
        local.getPicData(index: index)
    }
    
    func getPicDataNoSync() -> [PicData]? {
        return local.getPicData(isSynced: false)
    }
    
    func savePicData(picData: PicData) {
        local.savePicData(picData: picData)
    }
    
    func sync(onComplete:@escaping ()->Void, onNotConnected:()->Void) {
        
        if (!remote.isConnectedToInternet()) {
            onNotConnected()
        } else {
            let noSync = self.getPicDataNoSync()
            remote.upload(picDataList: noSync!) { filename, timestamp in
                let picData = PicData(name: filename, timestamp: timestamp)
                self.local.updatePicData(picData: picData)
                onComplete()
            }
        }
    }
    
    func getLimit() -> Limit? {
        return local.getLimit()
    }
}
