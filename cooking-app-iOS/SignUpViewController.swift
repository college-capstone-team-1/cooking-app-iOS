//
//  SignUpViewController.swift
//  cooking-app-iOS
//
//  Created by WS on 2022/11/27.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPW: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func BtnSignUp(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPW.text!) { (result, error) in
            
            guard let email = result?.user.email else {
                
                print("회원가입 실패")
                return
            }
            
            print("회원가입 성공[ \(email)")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
