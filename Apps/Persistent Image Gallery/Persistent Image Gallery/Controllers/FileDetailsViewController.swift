//
//  FileDetailsViewController.swift
//  Persistent Image Gallery
//
//  Created by Максим Митрофанов on 27.03.2023.
//

import UIKit

class FileDetailsViewController: UIViewController {
    
    var document: GalleryDocument? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var fileEditedDateLabel: UILabel!
    @IBOutlet weak var fileCreationDateLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let sizeThatFits = topStackView.systemLayoutSizeFitting(.zero)
        preferredContentSize = CGSize(width: sizeThatFits.width + 30, height: sizeThatFits.height + 100)
    }
    
    private var allOutletsAreSet: Bool {
        topStackView != nil &&
        fileSizeLabel != nil &&
        fileCreationDateLabel != nil
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    private func updateUI() {
        guard allOutletsAreSet,
            let filePath = document?.fileURL.path,
            let currentFileAttributes = try? FileManager.default.attributesOfItem(atPath: filePath)
        else { return }
        
        
        if let fileSize = currentFileAttributes[.size] as? Int {
            fileSizeLabel.text = fileSize.description + " bytes"
        }
        
        if let creationDate = currentFileAttributes[.creationDate] as? Date {
            fileCreationDateLabel.text = dateFormatter.string(from: creationDate)
        }
        
        if let presenter = presentationController as? UIPopoverPresentationController {
            view.backgroundColor = .clear
        }
        
        if let lastEditedDate = currentFileAttributes[.modificationDate] as? Date {
            fileEditedDateLabel.text = dateFormatter.string(from: lastEditedDate)
        }
    }
}

