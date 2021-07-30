//
//  ViewController.swift
//  SyncImage
//
//  Created by LordGift on 27/7/2564 BE.
//

import UIKit
import RealmSwift

class GalleryViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    var localRealm:Realm?
    
    lazy var viewModel: GalleryVM = {
        return GalleryVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.viewModel.localRealm = try! Realm()
        try! self.viewModel.localRealm?.write {
            self.viewModel.localRealm?.deleteAll()
        }
    }
    
    @IBAction func handleTapQR(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = .photoLibrary
            pickerVC.allowsEditing = true
            self.present(pickerVC, animated: true, completion: nil)
        }
    }
    
}

extension GalleryViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        var resizedImage = image
        print("\(Double(resizedImage.pngData()!.count)) Bytes")
        while resizedImage.pngData()!.count > 1_000_000 {
            resizedImage = resizedImage.resized(withPercentage: 0.9)!
            print("resized \(Double(resizedImage.pngData()!.count)) Bytes")
        }
        
        if let data = resizedImage.pngData() {
            let browseName = (info[.imageURL] as? URL)!.lastPathComponent
            
            
            let filename = Util.getDocumentsDirectory().appendingPathComponent(browseName)
            try? data.write(to: filename)
            
            let picData = PicData(path: browseName)
            try! self.viewModel.localRealm?.write {
                self.viewModel.localRealm?.add(picData)
            }
            
            self.collectionView.reloadData()
            
            dismiss(animated: true, completion: nil)
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let picData = self.viewModel.localRealm?.objects(PicData.self)
        return picData!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailCell", for: indexPath) as! ThumbnailCell
        let picData = self.viewModel.localRealm?.objects(PicData.self)
        
        if picData!.count > 0 {
            cell.setCell(picData: picData![indexPath.row])
        }

        return cell
    }
    
    
}
