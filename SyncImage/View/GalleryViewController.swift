//
//  ViewController.swift
//  SyncImage
//
//  Created by LordGift on 27/7/2564 BE.
//

import UIKit

class GalleryViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    lazy var viewModel: GalleryVM = {
        return GalleryVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleTapQR(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = .photoLibrary;
            
            pickerVC.allowsEditing = false
            self.present(pickerVC, animated: true, completion: nil)
        }
    }
    
}

extension GalleryViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage =  info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
