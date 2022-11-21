//
//  LoginViewController.swift
//  cooking-app-iOS
//
//  Created by WS on 2022/11/08.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //네이베이션바 제거, 스와이프 제스쳐는 가능
        self.navigationController?.navigationBar.isHidden = true;
        
 
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @IBAction func googleLogin(_ sender: Any) {
    }

    
    @IBAction func emailLogin(_ sender: Any) {
    }
    
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
