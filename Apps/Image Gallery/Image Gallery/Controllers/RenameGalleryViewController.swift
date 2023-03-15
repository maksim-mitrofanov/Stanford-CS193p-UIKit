//
//  RenameGalleryViewController.swift
//  Image Gallery
//
//  Created by Максим Митрофанов on 15.03.2023.
//

import UIKit

class RenameGalleryViewController: UIViewController {
    @IBOutlet private weak var stackViewBackground: UIView!
    @IBOutlet private weak var newNameTextField: UITextField!
    @IBOutlet private weak var oldNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackViewBackgroundAppearance()
        oldNameTextField.text = oldGalleryName
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let newName = newNameTextField.text {
            handler?(newName)
        }
    }
    
    private var oldGalleryName: String = ""
    private var handler: ((String) -> Void)?
    
    
    private func setupStackViewBackgroundAppearance() {
        stackViewBackground.layer.cornerRadius = 20
        stackViewBackground.layer.masksToBounds = false
        stackViewBackground.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        stackViewBackground.layer.shadowOffset = CGSize(width: 10, height: 10)
        stackViewBackground.layer.shadowRadius = 10
    }
    
    func setup(with value: String) {
        oldGalleryName = value
    }
    
    func renameAction(handler: @escaping (String) -> Void) {
        self.handler = handler
    }
}
