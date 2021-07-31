//
//  Remote.swift
//  SyncImage
//
//  Created by Lord Gift on 30/7/2564 BE.
//

import Alamofire
import UIKit

class Remote {
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func upload(picDataList: [PicData], onSuccess: ((String, String)->Void)?) {
        
        let url = URL(string: "http://localhost:8080/upload")!

        for picData in picDataList {
            let imageURL = Util.getDocumentsDirectory().appendingPathComponent(picData.name!)
            let image    = UIImage(contentsOfFile: imageURL.path)
            
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(image!.pngData()!, withName: "file" , fileName: picData.name, mimeType: "image/png")
            },
            to: url,
            method: .post,
            headers: nil)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        let filename = json["filename"] as! String
                        let timestamp = json["timestamp"] as! String
                        onSuccess?(filename, timestamp)
                    }
                    
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
        
        
        

    }
}
