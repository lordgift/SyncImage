//
//  LimitSettingViewController.swift
//  SyncImage
//
//  Created by Lord Gift on 1/8/2564 BE.
//

import UIKit

class LimitSettingViewController: UIViewController {
    @IBOutlet var pngLimitTextField: UITextField!
    @IBOutlet var jpgLimitTextField: UITextField!
    @IBOutlet var heicLimitTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleTapSave(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
