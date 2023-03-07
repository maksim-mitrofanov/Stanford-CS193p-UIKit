//
//  TextFieldCollectionViewCell.swift
//  EmojiArt
//
//  Created by Максим Митрофанов on 07.03.2023.
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    var resignationHandler: (() -> Void)?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
        textField.text?.removeAll()
    }
}
