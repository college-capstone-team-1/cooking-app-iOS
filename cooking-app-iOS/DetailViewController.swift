//
//  DetailViewController.swift
//  cooking-app-iOS
//
//  Created by 미미밍 on 2022/10/22.
//

import UIKit
import CoreData
import FirebaseAuth

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var lbDtls: UILabel!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var table: UITableView!
    
    var likeRecipeStatus = true
    var favoriteRecipeStatus = true
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
    var likeRecipes:[String?] = []
    
    struct Recipes {
        let id:Int
        let recipe_seq:Int
        let user_email:String
    }

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //좋아요버튼의 초기상태를 지정
        likeButtonController()
        //저장버튼색 초기상태를 지정
        favoriteButtonController()
        
        // correct the transparency bug for Tab bars
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        // correct the transparency bug for Navigation bars
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
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
    
    
    @IBAction func likeButton(_ sender: UIButton) {
        
        if likeRecipeStatus == true{
            //좋아요 취소
            disLikeRecipe()
            likeRecipeStatus = false
        }
        else{
            //좋아요
            likeRecipe()
            likeRecipeStatus = true
        }
        //좋아요 여부 확인 후 버튼색을 변경
        likeButtonController()
    }
    
    
    @IBAction func favoriteEntityController(_ sender: Any) {
        
        if favoriteRecipeStatus == true {
            deleteFavorite()
            favoriteRecipeStatus = false
        }
        else{
            addFavorite()
            favoriteRecipeStatus = true
        }
        
        //즐겨찾기 여부 확인 후 버튼색을 변경
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
                favoriteRecipeStatus = true
            }
            //레시피 검색결과가 없는 경우
            else{
                favoriteButton.setImage(UIImage(systemName: "tray.and.arrow.down"), for: .normal)
                favoriteButton.tintColor = .black
                favoriteRecipeStatus = false
            }
            
        }
        catch{
            print(error)
        }
    }
    
    func likeRecipe(){
        //uid추출은 위해 로그인여부 검증
        guard let uid = Auth.auth().currentUser?.uid else{
            showToast(message: "로그인이 필요합니다")
            return
        }
        //현재 레시피seq와 유저id를 담아 POST요청
        let urlString = "http://inndiary.xyz/api/v1/favorites/take/choose?uid=\(uid)&recipeSeq=\(recipeTuple.seq!)"
        let url = URL(string:urlString)
        var request = URLRequest(url:url!)
        request.httpMethod = "POST"
        
        var semaphore = DispatchSemaphore(value:0)
        
        URLSession.shared.dataTask(with: request){ (data, result, error) in
            //에러출력
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            guard let data = data else{return}
            //리턴된 json값을 key:value 형식으로 변환
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                //에러리턴시 error출력
                if let error =  json["error"] as? String  {
                    print("error:\(error)")
                    self.showToast(message: "알수 없는 에러가 발생")
                    return
                }
                //리턴된 값으로 등록여부 판단
                if let count = json["count"] as? Int{
                    if count == 0 {
                        self.showToast(message: "등록된 레시피입니다")
                    }
                    else{
                        self.showToast(message: "등록되었습니다")
                        //현재 레시피seq를 로컬저장소에 저장
                        NSEntityDescription.insertNewObject(forEntityName: "Like", into: self.context).setValue(self.recipeTuple.seq!, forKey: "recipe_seq")
                        
                        //영구저장소에 반영
                        if self.context.hasChanges{
                            do{
                                try self.context.save()
                                print("Added Data Saved")
                            } catch{
                                print(error)
                            }
                        }
                    }
                }
            }
            //로컬저장소에 값이 저장될때까지 종료하지 않음
            semaphore.signal()
        }.resume()
        
        //비동기메서드인 dataTask가 끝날때 까지 대기
        semaphore.wait()
        
    }
    
    
    func disLikeRecipe(){
        //uid추출은 위해 로그인여부 검증
        guard let uid = Auth.auth().currentUser?.uid else{
            showToast(message: "로그인이 필요합니다")
            return
        }
        //현재 레시피seq와 유저id를 담아 POST요청
        let urlString = "http://inndiary.xyz/api/v1/favorites/delete/choose?uid=\(uid)&recipeSeq=\(recipeTuple.seq!)"
        let url = URL(string:urlString)
        var request = URLRequest(url:url!)
        request.httpMethod = "POST"
        
        var semaphore = DispatchSemaphore(value:0)
        
        URLSession.shared.dataTask(with: request) { (data, result, error) in
            //에러출력
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            //리턴값 존재 확인
            guard let data = data else{return}
            
            //리턴값이 존재할 경우
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                //에러리턴시 error출력
                if let error =  json["error"] as? String  {
                    print("error:\(error)")
                    self.showToast(message: "알수 없는 에러가 발생")
                    return
                }
                //로컬저장소에 저장된 레시피seq까지 삭제
                let request = NSFetchRequest<NSManagedObject>(entityName: "Like")
                //현재 레시피seq 객체를 검색
                request.predicate = NSPredicate(format:"recipe_seq == %@", self.recipeTuple.seq!)
                
                do{
                    let result = try self.context.fetch(request)

                    guard let resultObject = result.first else { return }
                    
                    self.context.delete(resultObject)
                    
                    if self.context.hasChanges{
                        do{
                            try self.context.save()
                            print("Deleted Data Saved")
                        } catch{
                            print(error)
                        }
                    }
                }
                catch{
                    print("not found")
                }
                self.showToast(message: "삭제되었습니다")
                
                //로컬저장소에 값이 저장될때까지 종료하지 않음
                semaphore.signal()
            }
        }.resume()
        
        //비동기메서드인 dataTask가 끝날때 까지 대기
        semaphore.wait()
    }
    //좋아요버튼의 on/off 상태를 지정
    func likeButtonController() {
        
        guard let uid = Auth.auth().currentUser?.uid else{
            showToast(message: "로그인이 필요합니다")
            return
        }
        //로컬저장소에 저장된 모든 좋아요 리스트를 가져와 현재 레시피seq와 비교
        let request = NSFetchRequest<NSManagedObject>(entityName: "Like")
        do{
            let likes = try self.context.fetch(request)
            
            for like in likes{
                likeRecipes.append(like.value(forKey: "recipe_seq") as? String)
            }
            
            //해당 레시피와 좋아요목록에 일치하는 seq가 있는경우
            if likeRecipes.contains(self.recipeTuple.seq!) {
                //좋아요 활성화 상태로 변경
                self.likeRecipeStatus = true
                DispatchQueue.main.async {
                    self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    self.likeButton.tintColor = .red
                    self.likeRecipeStatus = true
                }
            }
            else{
                //좋아요 비활성화 상태로 변경
                self.likeRecipeStatus = false
                DispatchQueue.main.async {
                    self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    self.likeButton.tintColor = .black
                    self.likeRecipeStatus = false
                }
            }
        }
        catch{
            print(error)
        }
        likeRecipes = []
    }
    
    //토스트 label 생성
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {

        //UIlabel뷰 생성
        DispatchQueue.main.async {
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-150, width: 150, height: 30))
            toastLabel.text = message
            toastLabel.font = font
            toastLabel.textAlignment = .center
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0}, completion: {
                (isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    }
}
