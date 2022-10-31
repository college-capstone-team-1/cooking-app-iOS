//
//  DetailViewController.swift
//  cooking-app-iOS
//
//  Created by 미미밍 on 2022/10/22.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var lbDtls: UILabel!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var table: UITableView!
    
    var recipeTuple:(seq:String?,           //레시피 일련번호
                    name:String?,           //레시피 이름
                    way2:String?,           //조리방식
                    pat2:String?,           //요리종류
                    wtg:String?,            //중량(1인분)
                    eng:String?,            //열량(1인분)
                    car:String?,            //탄수화물
                    pro:String?,            //단백질
                    fat:String?,            //지방
                    na:String?,             //나트륨
                    tag:String?,            //해쉬태그
                    img:String?,            //이미지 경로
                    dtls:String?,           //재료 목록
                    manual:Array<String?>,  //만드는법 설명
                    manualImg:Array<String?> )!//만드는법 이미지

    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
        //테이블뷰 헤더 지정
        table.tableHeaderView = header
        //재료 라벨 줄바꿈 제한 없음
        lbDtls.numberOfLines = 0
        //레시피 이름 삽입
        lbName.text = recipeTuple.name!
        //레시피 재료 삽입
        lbDtls.text = recipeTuple.dtls!
        
//        let bottomConstraint = NSLayoutConstraint (item: header!,
//                                                  attribute: .bottom,
//                                                   relatedBy: .equal,
//                                                  toItem: lbDtls,
//                                                  attribute: .bottom,
//                                                  multiplier: 1,
//                                                  constant: 15)
//        //bottomConstraint.priority = UILayoutPriority(750)
//        //재료뷰 길이에 따라 헤더길이가 조절됨 @@s아님
//        lbDtls.addConstraint(bottomConstraint)
        
        //이미지 불러오기
        DispatchQueue.global().async {
            let imgURL = URL(string: self.recipeTuple.img!)
            if let imgData = try? Data(contentsOf: imgURL!){
                DispatchQueue.main.async {
                    self.mainImg?.image = UIImage(data:imgData)
                }
            }
        }
        
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeTuple.manual.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.description)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        
        cell.lbManual.text = recipeTuple.manual[indexPath.row]
        
        DispatchQueue.global().async{
            
            if let imgURL = URL(string: self.recipeTuple.manualImg[indexPath.row]!) {
                let imgData = try? Data(contentsOf: imgURL)
                DispatchQueue.main.async{
                    cell.imgManual.image = UIImage(data: imgData!)
                }
            }
        }
        
        
        //cell.rcpName.text = self.recipeData?.COOKRCP01.row[indexPath.row]?.RCP_NM
        
        
        //서버에 값이 없으면 ""을 전달하므로 nil이 아니라 옵셔널("")값이 저장됨
//        if let imgString = self.recipeData?.COOKRCP01.row[indexPath.row]?.ATT_FILE_NO_MAIN, imgString != "" {
//            DispatchQueue.global().async {
//
//                let imgURL = URL(string: self.recipeData?.COOKRCP01.row[indexPath.row]?.ATT_FILE_NO_MAIN! ?? "")
//                if let imgData = try? Data(contentsOf: imgURL!){
//
//                    DispatchQueue.main.async {
//                        cell.mainImg?.image = UIImage(data:imgData)
//                    }
//                }
//            }
//        }
        
        return cell
    }

}
