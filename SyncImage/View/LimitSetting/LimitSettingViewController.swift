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
    @IBOutlet var summaryLabel: UILabel!
    
    lazy var viewModel: LimitSettingVM = {
        return LimitSettingVM()
    }()
    
    
    private var onSave:((Limit)->Void)?
    
    func setupOnSave(onSave:@escaping ((Limit)->Void)) {
        self.onSave = onSave
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pngLimitTextField.addTarget(self, action: #selector(self.handleLimitChanged), for: .editingChanged)
        self.jpgLimitTextField.addTarget(self, action: #selector(self.handleLimitChanged), for: .editingChanged)
        self.heicLimitTextField.addTarget(self, action: #selector(self.handleLimitChanged), for: .editingChanged)
        
        
        let limit = self.viewModel.getLimit()
        self.pngLimitTextField.text = String(limit!.png!)
        self.jpgLimitTextField.text = String(limit!.jpg!)
        self.heicLimitTextField.text = String(limit!.heic!)
        self.styleSummary()
    }
    
    @IBAction func handleTapSave(_ sender: Any) {
        let limit = self.viewModel.editingLimit!
        
        if limit.png! + limit.jpg! + limit.heic! < 100 {
            let alert = UIAlertController(title: "Can't save!", message: "Summary all types not below 100", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.viewModel.setLimit(limit: limit)
            self.onSave?(limit)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func handleLimitChanged() {
        self.styleSummary()
    }
    
    private func styleSummary() {
        if self.viewModel.editingLimit == nil {
            self.viewModel.editingLimit = Limit()
        }
        
        let limit = self.viewModel.editingLimit!
        limit.png = Int(self.pngLimitTextField.text ?? "0") ?? 0
        limit.jpg = Int(self.jpgLimitTextField.text ?? "0") ?? 0
        limit.heic = Int(self.heicLimitTextField.text ?? "0") ?? 0
        
        let summaryLimit = limit.png! + limit.jpg! + limit.heic!
        
        var html = "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.summaryLabel.font!.pointSize)\">"
        if summaryLimit < 100 {
            html += "Summary : <b style='color:red'>\(summaryLimit)</b> files"
        } else {
            html += "Summary : <b>\(summaryLimit)</b> files"
        }
        html += "</span>"
        self.summaryLabel.attributedText = html.htmlToAttributedString
    }
}
