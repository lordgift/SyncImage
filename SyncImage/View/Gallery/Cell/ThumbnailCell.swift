//
//  ThumbnailCell.swift
//  SyncImage
//
//  Created by LordGift on 27/7/2564 BE.
//

import UIKit

class ThumbnailCell: UICollectionViewCell {
    
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var syncIconButton: UIButton!
    @IBOutlet var fileTypeLabel: UILabel!
    @IBOutlet var uploadTimestampLabel: UILabel!
    
    func setCell(picData: PicData) {
        let imageURL = Util.getDocumentsDirectory().appendingPathComponent(picData.name!)
        let image    = UIImage(contentsOfFile: imageURL.path)
        self.thumbnailImageView.image = image
        self.syncIconButton.isHighlighted =  picData.timestamp != nil
        self.fileTypeLabel.text = imageURL.pathExtension
        
        if picData.timestamp != nil {
            let date = toDate(from: picData.timestamp)
            self.uploadTimestampLabel.text = toString(from: date)
        } else {
            self.uploadTimestampLabel.text = nil
        }
        
    }
    
    private func toDate(from string: String?) -> Date? {
        guard let dateString = string else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSXXXXX"
        return formatter.date(from: dateString)
    }
    
    private func toString(from date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM\nHH:mm"
        return formatter.string(from: date)
    }
}
