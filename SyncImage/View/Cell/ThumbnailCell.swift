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
    
    func setCell(picData: PicData) {
        let imageURL = Util.getDocumentsDirectory().appendingPathComponent(picData.name!)
        let image    = UIImage(contentsOfFile: imageURL.path)
        self.thumbnailImageView.image = image
        self.syncIconButton.isHighlighted =  picData.timestamp != nil
    }

}
