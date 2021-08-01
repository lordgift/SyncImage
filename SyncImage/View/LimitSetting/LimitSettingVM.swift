//
//  LimitSettingVM.swift
//  SyncImage
//
//  Created by Lord Gift on 1/8/2564 BE.
//

import Foundation

class LimitSettingVM {
    
    var editingLimit:Limit?
    
    private var local = Local()
    
    func setLimit(limit: Limit) {
        local.setLimit(limit: limit)
    }
    
    func getLimit() -> Limit? {
        let limit = local.getLimit()
        self.editingLimit?.png = limit?.png
        self.editingLimit?.jpg = limit?.jpg
        self.editingLimit?.heic = limit?.heic
        return limit
    }
    
}
