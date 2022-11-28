//
//  LoginEmailViewController.swift
//  cooking-app-iOS
//
//  Created by WS on 2022/11/15.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginMainViewController: UIViewController {

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
            guard error == nil else {
                print("Email Auth ERROR: \(error?.localizedDescription)")
                return
            }
            
            //로그인상태 확인
            guard let user = result?.user else {
                print("Login Fail")
                return
            }
            print("Login Success: \(user.email)")
            
            //모달 닫기
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func googleLogin(_ sender: UIButton) {
        
        //구글 로그인
        startGoogleLogin()
    }
    
    func startGoogleLogin(){
        let googleClientId = "845968429936-onvrmj608gahso97munufkr3trm57824.apps.googleusercontent.com"
        let signInConfig = GIDConfiguration.init(clientID: googleClientId)

        let accessToken = GIDSignIn.sharedInstance.currentUser?.authentication.accessToken
        
        if accessToken == nil {
            
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { (userInfo, error) in
                if error != nil {

                } else {
                    //구글로그인 성공 판단
                    guard let authentication = userInfo?.authentication else { return }
                    //인증서 발행
                    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
                    print("credential:", credential)
                    
                    let userId = userInfo?.userID
                    let accessToken = userInfo?.authentication.accessToken
                    
                    //파이어베이스 인증
                    Auth.auth().signIn(with: credential) { result, error in
                        
                        //파이어베이스 로그인 실패
                        guard error == nil else{
                            print("Google Auth Error:", error?.localizedDescription)
                            GIDSignIn.sharedInstance.signOut()
                            return
                        }
                        
                        print("Google Auth: \((result?.user.email)!)")
                    }
                }
            }
        }
    }
}
