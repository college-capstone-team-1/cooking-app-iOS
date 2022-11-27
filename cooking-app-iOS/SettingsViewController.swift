//
//  SettingViewController.swift
//  cooking-app-iOS
//
//  Created by WS on 2022/11/15.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var txtEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //버튼 테두리 굵기
        loginBtn.layer.borderWidth = 2
        logoutBtn.layer.borderWidth = 2
        //버튼 테두리 색상
        loginBtn.layer.borderColor = UIColor.black.cgColor
        logoutBtn.layer.borderColor = UIColor.blue.cgColor
        
    }
    
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        
        txtEmail.text = "로그인이 필요합니다"
        try? Auth.auth().signOut()
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        let LoginSB = UIStoryboard(name: "Login", bundle: nil)
        let LoginNVC = LoginSB.instantiateViewController(withIdentifier: "LOGINNAV")
        LoginNVC.modalPresentationStyle = .fullScreen
        self.present(LoginNVC, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //화면이 다시 나타날 때 마다 로그인상태 체크
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("#######")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser {
            txtEmail.text = user.email
        }
        else{
            txtEmail.text = "로그인이 필요합니다"
        }
        
        print("@@@@@@")
    }
    
    

}
