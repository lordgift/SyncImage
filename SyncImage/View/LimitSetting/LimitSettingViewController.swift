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
    
    
    lazy var viewModel: LimitSettingVM = {
        return LimitSettingVM()
    }()
    
    
    private var onSave:((Limit)->Void)?
    
    func setupOnSave(onSave:@escaping ((Limit)->Void)) {
        self.onSave = onSave
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleTapSave(_ sender: Any) {
        let limit = Limit()
        limit.png = Int(self.pngLimitTextField.text ?? "0") ?? 0
        limit.jpg = Int(self.jpgLimitTextField.text ?? "0") ?? 0
        limit.heic = Int(self.heicLimitTextField.text ?? "0") ?? 0
        
        viewModel.setLimit(limit: limit)
        onSave?(limit)
        self.navigationController?.popViewController(animated: true)
    }
}
