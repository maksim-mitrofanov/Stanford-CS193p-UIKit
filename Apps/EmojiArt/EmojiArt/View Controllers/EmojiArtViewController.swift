//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Максим Митрофанов on 01.03.2023.
//

import UIKit

class EmojiArtViewController: UIViewController {

    @IBOutlet var dropZone: UIView!
    @IBOutlet weak var emojiArtView: EmojiArtView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emojiArtView.imageToDisplay = UIImage(named: "Curiosity_Selfie")
    }
}
