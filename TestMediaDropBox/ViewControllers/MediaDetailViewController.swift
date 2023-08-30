//
//  MediaDetailViewController.swift
//  TestMediaDropBox
//
//  Created by Igor Palyvoda on 28.08.2023.
//

import UIKit
class MediaDetailViewController: UIViewController {
    
    @IBOutlet private weak var photoName: UILabel!
    @IBOutlet private weak var lastChangesLabel: UILabel!
    @IBOutlet private weak var mediaImageView: UIImageView!
    @IBOutlet private weak var photoIdLabel: UILabel!
    @IBOutlet private weak var pathFolderLabel: UILabel!
    
    var mediaFile: MediaFile?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
    }
    
    private func configureContent() {
        if let mediaFile = mediaFile {
            MediaNetworkManager.shared.loadImage(for: mediaFile) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.mediaImageView.image = image
                }
            }
            if let name = mediaFile.name,
               let lastChanges = mediaFile.lastChanges,
               let path = mediaFile.path,
               let id = mediaFile.id {
                photoName.text = "name: \(name)"
                pathFolderLabel.text = "path: \(path)"
                photoIdLabel.text = id
                
                let formattedDate = dateFormatter.string(from: lastChanges)
                lastChangesLabel.text = "last changes: \(formattedDate)"
            }
        }
    }
}
