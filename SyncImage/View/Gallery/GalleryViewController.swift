//
//  ViewController.swift
//  SyncImage
//
//  Created by LordGift on 27/7/2564 BE.
//

import UIKit
import MobileCoreServices

class GalleryViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var pngAvailableLabel: UILabel!
    @IBOutlet var pngLimitLabel: UILabel!
    @IBOutlet var jpgAvailableLabel: UILabel!
    @IBOutlet var jpgLimitLabel: UILabel!
    @IBOutlet var heicAvailableLabel: UILabel!
    @IBOutlet var heicLimitLabel: UILabel!
    
    lazy var viewModel: GalleryVM = {
        return GalleryVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let limit = self.viewModel.getLimit()
        
        self.pngLimitLabel.text = limit == nil ? "??" : String(limit!.png!)
        self.jpgLimitLabel.text = limit == nil ? "??" : String(limit!.jpg!)
        self.heicLimitLabel.text = limit == nil ? "??" : String(limit!.heic!)
    }
    
    @IBAction func handleTapQR(_ sender: UIBarButtonItem) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.png,.jpeg, .heic], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func handleTapSync(_ sender: UIBarButtonItem) {
        self.viewModel.sync {
            self.collectionView.reloadData()
        } onNotConnected: {
            let alert = UIAlertController(title: "Unreachable Internet, please try again.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func handleTapSettingLimit(_ sender: UIButton) {
        self.performSegue(withIdentifier: "settingLimitSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingLimitSegue" {
            if let vc = segue.destination as? LimitSettingViewController {
                vc.setupOnSave { limit in
                    self.pngLimitLabel.text = String(limit.png!)
                    self.jpgLimitLabel.text = String(limit.jpg!)
                    self.heicLimitLabel.text = String(limit.heic!)
                }
            }
        }
    }
    
}

extension GalleryViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let image = UIImage(contentsOfFile: urls.first!.path) else {
            return
        }
        
        var resizedImage = image
        print("\(Double(resizedImage.pngData()!.count)) Bytes")
        while resizedImage.pngData()!.count > 1_000_000 {
            resizedImage = resizedImage.resized(withPercentage: 0.8)!
            print("resized \(Double(resizedImage.pngData()!.count)) Bytes")
        }
        
        if let data = resizedImage.pngData() {
            let browseName = urls.first!.lastPathComponent
            
            
            let filename = Util.getDocumentsDirectory().appendingPathComponent(browseName)
            print("Absolute Path : \(filename)")
            
            try? data.write(to: filename)
            
            let picData = PicData(name: browseName, timestamp: nil)
            self.viewModel.savePicData(picData: picData)
            
            self.collectionView.reloadData()
            
            dismiss(animated: true, completion: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}


extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.countPicData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailCell", for: indexPath) as! ThumbnailCell
        let picData = self.viewModel.getPicData(index: indexPath.row)
        if picData != nil {
            cell.setCell(picData: picData!)
        }
        return cell
    }
    
}
