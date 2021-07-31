//
//  GalleryVM.swift
//  SyncImage
//
//  Created by LordGift on 27/7/2564 BE.
//

import Foundation
import UIKit

class GalleryVM {
    
    var local = Local()
    var remote = Remote()
    
    func countPicData() -> Int {
        return local.getAllPicData()?.count ?? 0
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
    
    func sync(onComplete:@escaping ()->Void) {
        let noSync = self.getPicDataNoSync()
        remote.upload(picDataList: noSync!) { filename, timestamp in
            let picData = PicData(name: filename, timestamp: timestamp)
            self.local.updatePicData(picData: picData)
            onComplete()
        }
    }
}
