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
    
    private var onSave:((Int,Int,Int)->Void)?
    
    func setupOnSave(onSave:@escaping ((Int,Int,Int)->Void)) {
        self.onSave = onSave
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleTapSave(_ sender: Any) {
        
        let pngLimit = Int(self.pngLimitTextField.text ?? "0") ?? 0
        let jpgLimit = Int(self.jpgLimitTextField.text ?? "0") ?? 0
        let heicLimit = Int(self.heicLimitTextField.text ?? "0") ?? 0
        
        onSave?(pngLimit, jpgLimit, heicLimit)
        self.navigationController?.popViewController(animated: true)
    }
}
