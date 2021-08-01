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
    @IBOutlet var loadingView: UIView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    lazy var viewModel: GalleryVM = {
        return GalleryVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadLimitData()
    }
    
    @IBAction func handleTapBrowse(_ sender: UIBarButtonItem) {
        self.startLoading()
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.png,.jpeg, .heic], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func handleTapSync(_ sender: UIBarButtonItem) {
        self.viewModel.sync {
            self.collectionView.reloadData()
        } onNotConnected: {
            let alert = UIAlertController(title: "Unreachable Internet, please try again.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
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
                    self.viewModel.limit = limit
                    //viewWillAppear will triggered!
                }
            }
        }
    }
    
    private func reloadLimitData() {
        self.viewModel.countAvailableAndLimit()
        
        self.pngAvailableLabel.text = String(self.viewModel.countPng ?? 0)
        self.jpgAvailableLabel.text = String(self.viewModel.countJpg ?? 0)
        self.heicAvailableLabel.text = String(self.viewModel.countHeic ?? 0)
        
        self.pngLimitLabel.text = self.viewModel.limit == nil ? "??" : String(self.viewModel.limit!.png!)
        self.jpgLimitLabel.text = self.viewModel.limit == nil ? "??" : String(self.viewModel.limit!.jpg!)
        self.heicLimitLabel.text = self.viewModel.limit == nil ? "??" : String(self.viewModel.limit!.heic!)
    }
    
    private func startLoading() {
        self.loadingView.isHidden = false
        self.indicatorView.startAnimating()
    }
    
    private func stopLoading() {
        self.loadingView.isHidden = true
        self.indicatorView.stopAnimating()
    }
    
}

extension GalleryViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let image = UIImage(contentsOfFile: urls.first!.path) else {
            return
        }
        
        if urls.first!.pathExtension.uppercased() == "PNG" {
            if (self.viewModel.limit!.png! - self.viewModel.countPng!) < 1 {
                let alert = UIAlertController(title: "Can't upload!", message: "Maximum PNG limit reached", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: stopLoading)
                return
            }
        } else if urls.first!.pathExtension.uppercased() == "JPG" {
            if (self.viewModel.limit!.jpg! - self.viewModel.countJpg!) < 1 {
                let alert = UIAlertController(title: "Can't upload!", message: "Maximum JPG limit reached", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: stopLoading)
                return
            }
        } else if urls.first!.pathExtension.uppercased() == "HEIC" {
            if (self.viewModel.limit!.heic! - self.viewModel.countHeic!) < 1 {
                let alert = UIAlertController(title: "Can't upload!", message: "Maximum HEIC limit reached", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: stopLoading)
                return
            }
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
            self.reloadLimitData()
            dismiss(animated: true, completion: stopLoading)
        }
        dismiss(animated: true, completion: stopLoading)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: stopLoading)
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
