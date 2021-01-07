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
    
    func setCast(_ name: String,_ urlStringImgage: String) {
        
        nameCastLabel.text = name
        
        if let imageUrl = URL(string: "\(Constants.baseImageUrl)\(urlStringImgage)") {
            castImageView.sd_setImage(with: imageUrl, completed: nil)
        }
        
    }

}
