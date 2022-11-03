//
//  TabBarController.swift
//  cooking-app-iOS
//
//  Created by WS on 2022/11/03.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        // 탭바 적용
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground() //현재테마에 적절한 불투명한 색 적용
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        // 네비게이션바 적용
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }

}
