//
//  FavoriteViewController.swift
//  cooking-app-iOS
//
//  Created by WS on 2022/10/31.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var context: NSManagedObjectContext{
        
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        
        return app.persistentContainer.viewContext
    }
    
    struct Recipe{
        let RCP_SEQ:String?        //일련번호
        let RCP_NM:String?          //메뉴명
        let RCP_WAY2:String?        //조리방법
        let RCP_PAT2:String?        //요리종류
        let INFO_WGT:String?        //중량(1인분)
        let INFO_ENG:String?        //열량(1인분)
        let INFO_CAR:String?        //탄수화물
        let INFO_PRO:String?        //단백질
        let INFO_FAT:String?        //지방
        let INFO_NA:String?         //나트륨
        let HASH_TAG:String?        //해쉬태그
        let ATT_FILE_NO_MAIN:String?//이미지경로(소)
        let RCP_PARTS_DTLS:String?  //재료정보
        let MANUAL01:String?        //만드는법_01
        let MANUAL_IMG01:String?    //만드는법_이미지_01
        let MANUAL02:String?        //만드는법_02
        let MANUAL_IMG02:String?    //만드는법_이미지_02
        let MANUAL03:String?
        let MANUAL_IMG03:String?
        let MANUAL04:String?
        let MANUAL_IMG04:String?
        let MANUAL05:String?
        let MANUAL_IMG05:String?
        let MANUAL06:String?
        let MANUAL_IMG06:String?
        let MANUAL07:String?
        let MANUAL_IMG07:String?
        let MANUAL08:String?
        let MANUAL_IMG08:String?
        let MANUAL09:String?
        let MANUAL_IMG09:String?
        let MANUAL10:String?
        let MANUAL_IMG10:String?
        let MANUAL11:String?
        let MANUAL_IMG11:String?
        let MANUAL12:String?
        let MANUAL_IMG12:String?
        let MANUAL13:String?
        let MANUAL_IMG13:String?
        let MANUAL14:String?
        let MANUAL_IMG14:String?
        let MANUAL15:String?
        let MANUAL_IMG15:String?
        let MANUAL16:String?
        let MANUAL_IMG16:String?
        let MANUAL17:String?
        let MANUAL_IMG17:String?
        let MANUAL18:String?
        let MANUAL_IMG18:String?
        let MANUAL19:String?
        let MANUAL_IMG19:String?
        let MANUAL20:String?
        let MANUAL_IMG20:String?
    }
    
    var recipeData = [Recipe?]()
    var offset:Int = 0
    private var currentPage = 4
    
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var favoriteTableView: UITableView!
    
    
    @IBAction func searchBtn(_ sender: Any) {
        
        searchFavoriteByKeyword()
        
    }
    
    //데이터가 로드되기 전 스크롤링으로 마지막 인덱스에 여러번 도달하면 같은데이터를 여러번 요청하게되는 버그가 발생@@
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){

        if indexPath.row == currentPage {
            
            offset += 5
            currentPage += 5
            getFavoriteData(offset: offset)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        searchField.delegate = self
        //setupTextFields()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.recipeData.count  //페이지당 5개
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
        
        if let name = self.recipeData[indexPath.row]?.RCP_NM, let imgString = self.recipeData[indexPath.row]?.ATT_FILE_NO_MAIN {
            
            //레시피이름 지정
            cell.rcpName.text = name

            //메인이미지 가져오기
            DispatchQueue.global().async{
                let imgURL = URL(string: imgString)
                let imgData = try? Data(contentsOf: imgURL!)
                DispatchQueue.main.async{
                    cell.mainImg.image = UIImage(data:imgData!)
                }
            }
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.description)
    }
    
    //segue가 동작하기 전 호출
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let dest = segue.destination as? DetailViewController else {return}
        let myIndexPath = favoriteTableView.indexPathForSelectedRow!
        let row = myIndexPath.row
        
                            //일련번호
        dest.recipeTuple = (seq:recipeData[row]?.RCP_SEQ,
                            //음식 이름
                            name:recipeData[row]?.RCP_NM,
                            //조리방식
                            way2:recipeData[row]?.RCP_WAY2,
                            //요리종류
                            pat2:recipeData[row]?.RCP_PAT2,
                            //중량(1인분)
                            wtg:recipeData[row]?.INFO_WGT,
                            //열량(1인분)
                            eng:recipeData[row]?.INFO_ENG,
                            //탄수화물
                            car:recipeData[row]?.INFO_CAR,
                            //단백질
                            pro:recipeData[row]?.INFO_PRO,
                            //지방
                            fat:recipeData[row]?.INFO_FAT,
                            //나트륨
                            na:recipeData[row]?.INFO_NA,
                            //해쉬태그
                            tag:recipeData[row]?.HASH_TAG,
                            //음식 사진
                            img:recipeData[row]?.ATT_FILE_NO_MAIN,
                            //음식 재료
                            dtls:recipeData[row]?.RCP_PARTS_DTLS?.components(separatedBy: "\n").joined(),
                            //만드는법 배열
                            manual:[recipeData[row]?.MANUAL01, recipeData[row]?.MANUAL02, recipeData[row]?.MANUAL03, recipeData[row]?.MANUAL04, recipeData[row]?.MANUAL05, recipeData[row]?.MANUAL06, recipeData[row]?.MANUAL07, recipeData[row]?.MANUAL08, recipeData[row]?.MANUAL09, recipeData[row]?.MANUAL10, recipeData[row]?.MANUAL11, recipeData[row]?.MANUAL12, recipeData[row]?.MANUAL13, recipeData[row]?.MANUAL14, recipeData[row]?.MANUAL15, recipeData[row]?.MANUAL16, recipeData[row]?.MANUAL17, recipeData[row]?.MANUAL18, recipeData[row]?.MANUAL19, recipeData[row]?.MANUAL20].filter{ $0 != nil }.map{ Optional($0!.components(separatedBy: "\n").joined())},
                            //만드는법 사진링크 배열
                            manualImg:[recipeData[row]?.MANUAL_IMG01, recipeData[row]?.MANUAL_IMG02, recipeData[row]?.MANUAL_IMG03, recipeData[row]?.MANUAL_IMG04, recipeData[row]?.MANUAL_IMG05, recipeData[row]?.MANUAL_IMG06, recipeData[row]?.MANUAL_IMG07, recipeData[row]?.MANUAL_IMG08, recipeData[row]?.MANUAL_IMG09, recipeData[row]?.MANUAL_IMG10, recipeData[row]?.MANUAL_IMG11, recipeData[row]?.MANUAL_IMG12, recipeData[row]?.MANUAL_IMG13, recipeData[row]?.MANUAL_IMG14, recipeData[row]?.MANUAL_IMG15, recipeData[row]?.MANUAL_IMG16, recipeData[row]?.MANUAL_IMG17, recipeData[row]?.MANUAL_IMG18, recipeData[row]?.MANUAL_IMG19, recipeData[row]?.MANUAL_IMG20].filter{ $0 != nil }
                            )
    }
    
    //Core Data로 로컬 데이터를 fetch 후 변수에 저장
    func getFavoriteData(keyword:String = "", limit:Int = 5, offset:Int = 0){
                
        let request = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        
        //fetch할 최대 개수
        request.fetchLimit = limit
        //검색 시작점
        request.fetchOffset = offset
        //검색 키워드 지정
        if keyword != "" {
            request.predicate = NSPredicate(format:"rcp_nm CONTAINS[c] %@", keyword)
        }
        
        
        do{
            let favorites = try context.fetch(request)

            
            for favorite in favorites{
                
                let recipe:Recipe = Recipe(RCP_SEQ: favorite.value(forKey: "rcp_seq") as? String,          //일련번호
                                           RCP_NM: favorite.value(forKey: "rcp_nm") as? String,            //메뉴명
                                           RCP_WAY2: favorite.value(forKey: "rcp_way2") as? String,        //조리방법
                                           RCP_PAT2: favorite.value(forKey: "rcp_pat2") as? String,        //요리종류
                                           INFO_WGT: favorite.value(forKey: "info_wgt") as? String,        //중량(1인분)
                                           INFO_ENG: favorite.value(forKey: "info_eng") as? String,        //열량(1인분)
                                           INFO_CAR: favorite.value(forKey: "info_car") as? String,        //탄수화물
                                           INFO_PRO: favorite.value(forKey: "info_pro") as? String,        //단백질
                                           INFO_FAT: favorite.value(forKey: "info_fat") as? String,        //지방
                                           INFO_NA: favorite.value(forKey: "info_na") as? String,          //나트륨
                                           HASH_TAG: favorite.value(forKey: "hash_tag") as? String,        //해쉬태그
                                           ATT_FILE_NO_MAIN: favorite.value(forKey: "att_file_no_main") as? String,//이미지경로(소)
                                           RCP_PARTS_DTLS: favorite.value(forKey: "rcp_parts_dtls") as? String,//재료정보
                                           MANUAL01: favorite.value(forKey: "manual01") as? String,        //만드는법_01
                                           MANUAL_IMG01: favorite.value(forKey: "manual_img01") as? String,//만드는법_이미지_01
                                           MANUAL02: favorite.value(forKey: "manual02") as? String,        //만드는법_02
                                           MANUAL_IMG02: favorite.value(forKey: "manual_img02") as? String,//만드는법_이미지_02
                                           MANUAL03: favorite.value(forKey: "manual03") as? String,
                                           MANUAL_IMG03: favorite.value(forKey: "manual_img03") as? String,
                                           MANUAL04: favorite.value(forKey: "manual04") as? String,
                                           MANUAL_IMG04: favorite.value(forKey: "manual_img04") as? String,
                                           MANUAL05: favorite.value(forKey: "manual05") as? String,
                                           MANUAL_IMG05: favorite.value(forKey: "manual_img05") as? String,
                                           MANUAL06: favorite.value(forKey: "manual06") as? String,
                                           MANUAL_IMG06: favorite.value(forKey: "manual_img06") as? String,
                                           MANUAL07: favorite.value(forKey: "manual07") as? String,
                                           MANUAL_IMG07: favorite.value(forKey: "manual_img07") as? String,
                                           MANUAL08: favorite.value(forKey: "manual08") as? String,
                                           MANUAL_IMG08: favorite.value(forKey: "manual_img08") as? String,
                                           MANUAL09: favorite.value(forKey: "manual09") as? String,
                                           MANUAL_IMG09: favorite.value(forKey: "manual_img09") as? String,
                                           MANUAL10: favorite.value(forKey: "manual10") as? String,
                                           MANUAL_IMG10: favorite.value(forKey: "manual_img10") as? String,
                                           MANUAL11: favorite.value(forKey: "manual11") as? String,
                                           MANUAL_IMG11: favorite.value(forKey: "manual_img11") as? String,
                                           MANUAL12: favorite.value(forKey: "manual12") as? String,
                                           MANUAL_IMG12: favorite.value(forKey: "manual_img12") as? String,
                                           MANUAL13: favorite.value(forKey: "manual13") as? String,
                                           MANUAL_IMG13: favorite.value(forKey: "manual_img13") as? String,
                                           MANUAL14: favorite.value(forKey: "manual14") as? String,
                                           MANUAL_IMG14: favorite.value(forKey: "manual_img14") as? String,
                                           MANUAL15: favorite.value(forKey: "manual15") as? String,
                                           MANUAL_IMG15: favorite.value(forKey: "manual_img15") as? String,
                                           MANUAL16: favorite.value(forKey: "manual16") as? String,
                                           MANUAL_IMG16: favorite.value(forKey: "manual_img16") as? String,
                                           MANUAL17: favorite.value(forKey: "manual17") as? String,
                                           MANUAL_IMG17: favorite.value(forKey: "manual_img17") as? String,
                                           MANUAL18: favorite.value(forKey: "manual18") as? String,
                                           MANUAL_IMG18: favorite.value(forKey: "manual_img18") as? String,
                                           MANUAL19: favorite.value(forKey: "manual19") as? String,
                                           MANUAL_IMG19: favorite.value(forKey: "manual_img19") as? String,
                                           MANUAL20: favorite.value(forKey: "manual20") as? String,
                                           MANUAL_IMG20: favorite.value(forKey: "manual_img20") as? String)

                recipeData.append(recipe)
            }
            
            DispatchQueue.main.async{
                
                self.favoriteTableView.reloadData()
            }
            
        }catch{
            print(error)
        }
    }
    
    //키보드 Return버튼을 누르면 키보드가 내려감
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                
        searchFavoriteByKeyword()
        return true
    }
    
    //데이터 초기화 및 검색 키워드 추출
    func searchFavoriteByKeyword(){
        
        //검색 키워드
        guard let search = searchField.text else { return }
        
        //테이블뷰를 최상단으로 이동
        if recipeData.count != 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            favoriteTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
        //데이터를 처음부터 찾기 위해 초기화
        currentPage = 4
        offset = 0
        //기존데이터 삭제
        recipeData.removeAll()
        
        getFavoriteData(keyword: search, offset: offset)
        searchField.resignFirstResponder()
        
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
}
