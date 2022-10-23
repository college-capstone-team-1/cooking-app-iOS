//
//  DetailTableViewCellController.swift
//  cooking-app-iOS
//
//  Created by 미미밍 on 2022/10/22.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lbManual: UILabel!
    @IBOutlet weak var imgManual: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code 셀이 최초로 생성될 때 호출됨
        lbManual.numberOfLines = 0
        self.selectionStyle = .none

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //셀을 재사용할 때 마다 호출
        
        //mainImg.image = nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
