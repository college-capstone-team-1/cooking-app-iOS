//
//  HomeCollectionViewCell.swift
//  cooking-app-iOS
//
//  Created by WS on 2022/12/10.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        
        //배너 그라데이션 생성
        let gradientLayer = CAGradientLayer()
        let colors:[CGColor] = [ .init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), .init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)]
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x:0.5, y:1.0)
        gradientLayer.frame = imageView.bounds
        imageView.layer.addSublayer(gradientLayer)
    }
}
