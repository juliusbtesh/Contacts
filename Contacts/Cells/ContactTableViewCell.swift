//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Julius Btesh on 5/13/19.
//  Copyright © 2019 Julius Btesh. All rights reserved.
//

import UIKit
import Kingfisher

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactThumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var favoriteLabel: UILabel!
        
    public var contact: Contact? {
        didSet {
            let oldId = oldValue?.id ?? ""
            let newId = self.contact?.id ?? ""
//
            if !oldId.elementsEqual(newId) {
                self.favoriteLabel?.isHidden = !(contact?.isFavorite ?? true) 
                self.titleLabel?.text = contact?.name
                self.subtitleLabel?.text = contact?.companyName

                //
                let processor =  DownsamplingImageProcessor(size: contactThumbnailView.frame.size)
                contactThumbnailView.layer.cornerRadius = contactThumbnailView.frame.size.width/2
                contactThumbnailView.kf.setImage(
                    with: URL(string: contact?.smallImageURL ?? ""),
                    placeholder: UIImage(named: Constants.Images.DefaultUserImageSmall),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .cacheOriginalImage,
                    ])
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
