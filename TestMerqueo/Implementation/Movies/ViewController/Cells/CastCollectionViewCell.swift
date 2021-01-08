//
//  CastCollectionViewCell.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 6/01/21.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var nameCastLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCast(_ cast: Cast) {
        
        if let name = cast.name {
            DispatchQueue.main.async {
                self.nameCastLabel.text = name
            }
        }
        
        if let imageString = cast.profilePath, let imageUrl = URL(string: "\(Constants.baseImageUrl)\(imageString)") {
            castImageView.sd_setImage(with: imageUrl, completed: nil)
        } else {
            DispatchQueue.main.async {
                self.castImageView.image = #imageLiteral(resourceName: "ic_no_image")
                self.castImageView.contentMode = .scaleAspectFit
            }
            
        }
        
    }

}
