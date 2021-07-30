//
//  GalleryVM.swift
//  SyncImage
//
//  Created by LordGift on 27/7/2564 BE.
//

import Foundation
import UIKit
import RealmSwift

class GalleryVM {
    var selectedImage:UIImage?
    var localRealm:Realm?
    
    func getPicData(index: Int) -> PicData? {
        return localRealm?.objects(PicData.self)[index]
    }
    
    func savePicData(picData: PicData) {
        try! self.localRealm?.write {
            self.localRealm?.add(picData)
        }
    }
}
