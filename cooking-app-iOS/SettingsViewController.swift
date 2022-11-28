//
//  SettingViewController.swift
//  cooking-app-iOS
//
//  Created by WS on 2022/11/15.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class SettingsViewController: UIViewController {


    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var txtEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //버튼 테두리 굵기
        loginBtn.layer.borderWidth = 2
        //버튼 테두리 색상
        loginBtn.layer.borderColor = UIColor.black.cgColor
        
    }
    

    @IBAction func loginBtn(_ sender: Any) {
        
        //로그인상태 체크
        if Auth.auth().currentUser != nil {
            //로그인 상태
            
            //로그아웃
            try? Auth.auth().signOut()
            //구글 로그아웃
            GIDSignIn.sharedInstance.signOut()
            
            //로그인버튼 변경
            txtEmail.text = "로그인이 필요합니다"
            loginBtn.layer.borderColor = UIColor.black.cgColor
            loginBtn.setTitle("로그인 / 회원가입", for: .normal)
            
        }
        else{
            //로그아웃 상태
            
            //로그인페이지로 이동
            let LoginSB = UIStoryboard(name: "Login", bundle: nil)
            let LoginNVC = LoginSB.instantiateViewController(withIdentifier: "LOGINNAV")

            LoginNVC.modalPresentationStyle = .fullScreen
            self.present(LoginNVC, animated: true)
        }
        
    }


    override func viewDidAppear(_ animated: Bool) {
        //화면이 다시 나타날 때 마다 로그인상태 체크
        if let user = Auth.auth().currentUser {
            //로그인 상태
            txtEmail.text = user.email
            loginBtn.layer.borderColor = UIColor.red.cgColor
            loginBtn.setTitle("로그아웃", for: .normal)
        }
        else{
            //로그아웃 상태
            txtEmail.text = "로그인이 필요합니다"
            loginBtn.layer.borderColor = UIColor.black.cgColor
            loginBtn.setTitle("로그인 / 회원가입", for: .normal)
        }
    }
}
