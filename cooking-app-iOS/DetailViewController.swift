//
//  DetailViewController.swift
//  cooking-app-iOS
//
//  Created by 미미밍 on 2022/10/22.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var lbDtls: UILabel!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var table: UITableView!
    
    var favoriteRecipe = true
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

    var context: NSManagedObjectContext{
        
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        
        return app.persistentContainer.viewContext
    }
    
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
        
        //@@@@ favorite버튼  디폴트상태 정하는 코드 추가
        //버튼색 변경
        favoriteButtonController()
        
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
        
        return cell
    }
    
    @IBAction func favoriteEntityController(_ sender: Any) {
        
        if favoriteRecipe == true {
            deleteFavorite()
            favoriteRecipe = false
        }
        else{
            addFavorite()
            favoriteRecipe = true
        }
        
        //즐겨찾기 버튼 활성화 여부확인 후 조작
        favoriteButtonController()
    }

    //데이터를 영구저장소에 저장
    func addFavorite(){
        
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: context)
        
        //레시피 일련번호
        newEntity.setValue(recipeTuple.seq, forKey: "rcp_seq")
        //조리방식
        newEntity.setValue(recipeTuple.way2, forKey: "rcp_way2")
        //요리종류
        newEntity.setValue(recipeTuple.pat2, forKey: "rcp_pat2")
        //중량(1인분)
        newEntity.setValue(recipeTuple.wtg, forKey: "info_wgt")
        //열량(1인분)
        newEntity.setValue(recipeTuple.eng, forKey: "info_eng")
        //탄수화물
        newEntity.setValue(recipeTuple.car, forKey: "info_car")
        //단백질
        newEntity.setValue(recipeTuple.pro, forKey: "info_pro")
        //지방
        newEntity.setValue(recipeTuple.fat, forKey: "info_fat")
        //나트륨
        newEntity.setValue(recipeTuple.na, forKey: "info_na")
        //해쉬태그
        newEntity.setValue(recipeTuple.tag, forKey: "hash_tag")
        //재료 목록
        newEntity.setValue(recipeTuple.dtls, forKey: "rcp_parts_dtls")
        //레시피 이름
        newEntity.setValue(recipeTuple.name, forKey: "rcp_nm")
        //메인사진(소)
        newEntity.setValue(recipeTuple.img, forKey: "att_file_no_main")

        //만드는법 설명
        recipeTuple.manual.indices.forEach{
            
            var keyString = "manual"
            if $0 < 10 {keyString += "0"}  //manual00 형식 맞춤
            keyString += String($0 + 1)
            newEntity.setValue(recipeTuple.manual[$0], forKey: keyString)
        }
        
        //만드는법 사진
        recipeTuple.manualImg.indices.forEach{
            
            var keyString = "manual_img"
            if $0 < 10 {keyString += "0"}  //manual_img00 형식 맞춤
            keyString += String($0 + 1)
            newEntity.setValue(recipeTuple.manualImg[$0], forKey: keyString)
        }
        
        //context변경사항을 영구저장소에 저장
        if context.hasChanges{
            
            do{
                try context.save()
                print("Added Data Saved")
            } catch{
                print(error)
            }
        }
    }
    
    //영구저장소에 저장된 데이터를 삭제
    func deleteFavorite(){
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        //특정 레시피 검색
        request.predicate = NSPredicate(format:"rcp_seq == %@", recipeTuple.seq!)
        
        do{
            let result = try context.fetch(request)

            guard let resultFirst = result.first else { return }
            
            context.delete(resultFirst)
            
            if context.hasChanges{
                do{
                    try context.save()
                    print("Deleted Data Saved")
                } catch{
                    print(error)
                }
            }
        }
        catch{
            print("not found")
        }
    }
    
    //즐겨찾기 버튼 활성화 여부확인 후 조작
    func favoriteButtonController(){
        //이미 존재하는 레시피인지 검증
        let request = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        request.predicate = NSPredicate(format:"rcp_seq == %@", recipeTuple.seq!)
        
        
        do{
            let result = try context.fetch(request)
            
            //검색결과가 있는 경우
            if result.count > 0 {
                favoriteButton.setImage(UIImage(systemName: "tray.and.arrow.down.fill"), for: .normal)
                favoriteButton.tintColor = UIColor(cgColor: CGColor(red: 78/255, green: 105/255, blue: 113/255, alpha: 1))
                favoriteRecipe = true
            }
            //레시피 검색결과가 없는 경우
            else{
                favoriteButton.setImage(UIImage(systemName: "tray.and.arrow.down"), for: .normal)
                favoriteButton.tintColor = .black
                favoriteRecipe = false
            }
            
        }
        catch{
            print(error)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        // correct the transparency bug for Tab bars
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        // correct the transparency bug for Navigation bars
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    override func viewWillDisappear(_ animated: Bool) {
        // correct the transparency bug for Tab bars
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        // correct the transparency bug for Navigation bars
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}
