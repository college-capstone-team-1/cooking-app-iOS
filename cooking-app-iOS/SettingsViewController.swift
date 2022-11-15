//
//  SettingViewController.swift
//  cooking-app-iOS
//
//  Created by WS on 2022/11/15.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //로그인버튼 테두리 굵기
        loginBtn.layer.borderWidth = 2
        //로그인버튼 테두리 색상
        loginBtn.layer.borderColor = UIColor.black.cgColor
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
