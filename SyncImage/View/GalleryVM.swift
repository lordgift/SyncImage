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
    
    func countPicData() -> Int {
        return local.getAllPicData()?.count ?? 0
    }
    
    func getPicData(index: Int) -> PicData? {
        local.getPicData(index: index)
    }
    
    func savePicData(picData: PicData) {
        local.savePicData(picData: picData)
    }
}
