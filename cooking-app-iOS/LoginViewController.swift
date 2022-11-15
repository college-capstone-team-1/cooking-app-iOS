//
//  LoginViewController.swift
//  cooking-app-iOS
//
//  Created by WS on 2022/11/08.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //네이베이션바 제거, 스와이프 제스쳐는 가능
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    @IBAction func googleLogin(_ sender: Any) {
    }
    
    @IBAction func guestLogin(_ sender: Any) {
//        let mainVC = UIStoryboard.init(name: "Main", bundle: nil)
//        guard let MainController = mainVC.instantiateViewController(withIdentifier: "MainStoryboard")as? MainViewController else {return}
//
//        MainController.modalPresentationStyle = .fullScreen
//        self.present(MainController, animated: true, completion: nil)
    }
    
    
    @IBAction func emailLogin(_ sender: Any) {
    }
    
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
