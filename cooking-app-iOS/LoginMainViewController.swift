//
//  LoginEmailViewController.swift
//  cooking-app-iOS
//
//  Created by WS on 2022/11/15.
//

import UIKit
import FirebaseAuth

class LoginMainViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPw: UITextField!
    @IBOutlet weak var btnGoogleLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //오른쪽 네비게이션바에 닫기버튼 생성
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "닫기",
            style: .done,
            target: self,
            action: #selector(dismissVC)
        )
        
        //네비게이션바 외형변경
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowColor = .clear     //bottom라인 제거
        navigationBarAppearance.backgroundColor = .white //색상 변경
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
    }
    
    @objc func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: self.txtEmail.text!, password: self.txtPw.text!) { (result, error) in
            //에러출력
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            
            //로그인 확인
            guard let user = result?.user else {
                print("Login Fail")
                return
            }
            print("Login Successk: \(user.email)")
            
            //모달 닫기
            self.dismiss(animated: true, completion: nil)
        }
    }

}
