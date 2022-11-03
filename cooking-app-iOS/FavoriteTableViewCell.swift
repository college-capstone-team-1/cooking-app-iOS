//
//  FavoriteTableViewCell.swift
//  cooking-app-iOS
//
//  Created by WS on 2022/10/31.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var rcpName: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code 셀이 최초로 생성될 때 호출됨
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //셀을 재사용할 때 마다 호출
        
        //mainImg.image = nil
    }
}
