//
//  MovieCollectionViewCell.swift
//  TestMerqueo
//
//  Created by Juan Esteban Monsalve Echeverry on 6/01/21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func getImageForMovie(_ urlStringImgage: String) {
        
        if let imageUrl = URL(string: "\(Constants.baseImageUrl)\(urlStringImgage)") {
            movieImageView.sd_setImage(with: imageUrl, completed: nil)
            movieImageView.contentMode = .scaleAspectFit
            
        }
        
    }

}
