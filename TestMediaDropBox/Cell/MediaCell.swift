//
//  MediaCell.swift
//  TestMediaDropBox
//
//  Created by Igor Palyvoda on 27.08.2023.
//

import UIKit

class MediaCell: UITableViewCell {
    
    @IBOutlet weak var photoName: UILabel?
    @IBOutlet weak var photoView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetCellContent()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCellContent()
    }

    private func resetCellContent() {
        photoView?.image = nil
        photoName?.text = nil
    }
    
    func configure(with mediaFile: MediaFile) {
        photoName?.text = mediaFile.name
        
        MediaNetworkManager.shared.loadImage(for: mediaFile) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.photoView?.image = image
            }
        }
    }
}

