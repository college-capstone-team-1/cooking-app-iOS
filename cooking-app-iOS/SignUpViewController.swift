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
            
            if error != nil{
                print("error: \(error?.localizedDescription)")
                switch error?.localizedDescription {
                    
                case "The email address is already in use by another account.":
                    self.showToast(message: "이미 등록된 이메일입니다")
                    print("!")
                    
                default:
                    self.showToast(message: "회원가입 실패")
                }
                return
            }
            
            guard let email = result?.user.email else {
                
                print("회원가입 실패")
                return
            }
            
            print("회원가입 성공[ \(email)")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.5, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0},
                       completion: {(isCompleted) in toastLabel.removeFromSuperview() })
    }
    
}
