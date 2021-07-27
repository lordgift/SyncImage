//
//  ViewController.swift
//  SyncImage
//
//  Created by LordGift on 27/7/2564 BE.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    lazy var viewModel: GalleryVM = {
        return GalleryVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

