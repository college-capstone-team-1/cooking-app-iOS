//
//  LoginEmailViewController.swift
//  cooking-app-iOS
//
//  Created by WS on 2022/11/15.
//

import UIKit
import FirebaseAuth

class LoginEmailViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPw: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
