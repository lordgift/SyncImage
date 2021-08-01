//
//  LimitSettingVM.swift
//  SyncImage
//
//  Created by Lord Gift on 1/8/2564 BE.
//

import Foundation

class LimitSettingVM {
    private var local = Local()
    
    func setLimit(limit: Limit) {
        local.setLimit(limit: limit)
    }
    
    func getLimit() -> Limit? {
        return local.getLimit()
    }
    
}
