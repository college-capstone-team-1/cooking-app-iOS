//
//  ViewController.swift
//  EcoRecipe
//
//  Created by 미미밍 on 2022/10/05.
//

import UIKit
import CoreData
import FirebaseAuth

class ViewController: UIViewController, UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate {
    
    var context: NSManagedObjectContext{
        
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        
        return app.persistentContainer.viewContext
    }
    
    @IBOutlet var searchField: UITextField!
    @IBOutlet weak var mainTableView: UITableView!
    
    
    struct RCP:Codable{
        //var COOKRCP01:CookRCP01
        var meta:RCPMeta
        var values:[RCPValue?]
    }
    
    struct RCPMeta:Codable{
        var end:Bool?
        var total_count:Int?
        var pageable_count:Int?
    }
    
    struct RCPValue:Codable{
        var id:Int?
        let rcpSeq:Int?         //일련번호
        let rcpNm:String?          //메뉴명
        let rcpWay2:String?        //조리방법
        let rcpPat2:String?        //요리종류
        let rcpPartsDtls:String?  //재료정보
        let hashTag:String?       //해시태그
        let infoWgt:Double?       //중량(1인분)
        let infoEng:Double?       //열량(1인분)
        let infoCar:Double?       //탄수화물
        let infoPro:Double?       //단백질
        let infoFat:Double?       //지방
        let infoNa:Double?         //나트륨
        let attFileNoMain:String?//이미지경로(소)
        let attFileNoMk:String?  //이미지경로(대)
        let manual01:String?        //만드는법_01
        let manual02:String?        //만드는법_02
        let manual03:String?        //만드는법_03
        let manual04:String?        //만드는법_04
        let manual05:String?        //만드는법_05
        let manual06:String?        //만드는법_06
        let manual07:String?        //만드는법_07
        let manual08:String?        //만드는법_08
        let manual09:String?        //만드는법_09
        let manual10:String?        //만드는법_10
        let manual11:String?        //만드는법_11
        let manual12:String?        //만드는법_12
        let manual13:String?        //만드는법_13
        let manual14:String?        //만드는법_14
        let manual15:String?        //만드는법_15
        let manual16:String?        //만드는법_16
        let manual17:String?        //만드는법_17
        let manual18:String?        //만드는법_18
        let manual19:String?        //만드는법_19
        let manual20:String?        //만드는법_20
        let manualImg01:String?     //만드는법_이미지_01
        let manualImg02:String?     //만드는법_이미지_02
        let manualImg03:String?     //만드는법_이미지_03
        let manualImg04:String?     //만드는법_이미지_04
        let manualImg05:String?     //만드는법_이미지_05
        let manualImg06:String?     //만드는법_이미지_06
        let manualImg07:String?     //만드는법_이미지_07
        let manualImg08:String?     //만드는법_이미지_08
        let manualImg09:String?     //만드는법_이미지_09
        let manualImg10:String?     //만드는법_이미지_10
        let manualImg11:String?     //만드는법_이미지_11
        let manualImg12:String?     //만드는법_이미지_12
        let manualImg13:String?     //만드는법_이미지_13
        let manualImg14:String?     //만드는법_이미지_14
        let manualImg15:String?     //만드는법_이미지_15
        let manualImg16:String?     //만드는법_이미지_16
        let manualImg17:String?     //만드는법_이미지_17
        let manualImg18:String?     //만드는법_이미지_18
        let manualImg19:String?     //만드는법_이미지_19
        let manualImg20:String?     //만드는법_이미지_20
    }
    
    var recipeData:RCP? = nil
    var startIndex:Int = 1
    var endIndex:Int = 5
    private
    var keyword:String?
    //호출해야할 api 페이지
    var recipePage = 1
    //현재 api 페이지
    var currentPage = 0
    //api로 한번에 받아올 레시피 개수
    let recipeSize = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        searchField.delegate = self
        setupTextFields()
        
        //검색바 돋보기이미지 생성 및 배치
        let imageView = UIImageView(frame: CGRect(x: 5, y: 2, width: 25, height: 25))
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "ic_search.png")
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30 , height: 30))
        leftView.addSubview(imageView)
 
        searchField.leftView = leftView
        searchField.leftViewMode = .always
        //Clear버튼 활성화
        searchField.clearButtonMode = .whileEditing
        
        //앱구동시 좋아요목록 초기화
        initailizeLikeReciper()
        
        //레시피 검색
        getRecipeData()
    }

    @IBAction func searchBtn(_ sender: Any) {
        
        SearchRecipe(keyword: searchField.text)
    }
    
    //키보드 Return버튼을 누르면 키보드가 내려감
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        SearchRecipe(keyword: searchField.text)
        
        searchField.resignFirstResponder()
        
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.recipeData?.values.count ?? 0  //페이지당 5개
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCell", for: indexPath) as! MainTableViewCell
        
        cell.rcpName.text = self.recipeData?.values[indexPath.row]?.rcpNm
        
        
        //서버에 값이 없으면 ""을 전달하므로 nil이 아니라 옵셔널("")값이 저장됨
        if let imgString = self.recipeData?.values[indexPath.row]?.attFileNoMain, imgString != "" {
            DispatchQueue.global().async {
                
                let imgURL = URL(string: self.recipeData?.values[indexPath.row]?.attFileNoMain! ?? "")
                if let imgData = try? Data(contentsOf: imgURL!){
                    
                    DispatchQueue.main.async {
                        cell.mainImg?.image = UIImage(data:imgData)
                    }
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
        let myIndexPath = mainTableView.indexPathForSelectedRow!
        let row = myIndexPath.row
        //Int, Double 형태로 받아온 데이터를 모두 String으로 변환
                            //일련번호
        dest.recipeTuple = (seq:String((recipeData?.values[row]?.rcpSeq)!),
                            //음식 이름
                            name:recipeData?.values[row]?.rcpNm,
                            //조리방식
                            way2:recipeData?.values[row]?.rcpWay2,
                            //요리종류
                            pat2:recipeData?.values[row]?.rcpPat2,
                            //중량(1인분)
                            wtg:String((recipeData?.values[row]?.infoWgt)!),
                            //열량(1인분)
                            eng:String((recipeData?.values[row]?.infoEng)!),
                            //탄수화물
                            car:String((recipeData?.values[row]?.infoCar)!),
                            //단백질
                            pro:String((recipeData?.values[row]?.infoPro)!),
                            //지방
                            fat:String((recipeData?.values[row]?.infoFat)!),
                            //나트륨
                            na:String((recipeData?.values[row]?.infoNa)!),
                            //해쉬태그
                            tag:recipeData?.values[row]?.hashTag,
                            //음식 사진
                            img:recipeData?.values[row]?.attFileNoMain,
                            //음식 재료
                            dtls:recipeData?.values[row]?.rcpPartsDtls?.components(separatedBy: "\n").joined(),
                            //만드는법 배열
                            manual:[recipeData?.values[row]?.manual01,recipeData?.values[row]?.manual02,recipeData?.values[row]?.manual03,recipeData?.values[row]?.manual04,recipeData?.values[row]?.manual05,recipeData?.values[row]?.manual06,recipeData?.values[row]?.manual07, recipeData?.values[row]?.manual08, recipeData?.values[row]?.manual09, recipeData?.values[row]?.manual10].filter{ $0 != ""}.map{ Optional($0!.components(separatedBy: "\n").joined())},
                            //만드는법 사진링크 배열
                            manualImg:[recipeData?.values[row]?.manualImg01, recipeData?.values[row]?.manualImg02, recipeData?.values[row]?.manualImg03, recipeData?.values[row]?.manualImg04, recipeData?.values[row]?.manualImg05, recipeData?.values[row]?.manualImg06, recipeData?.values[row]?.manualImg07, recipeData?.values[row]?.manualImg08, recipeData?.values[row]?.manualImg09, recipeData?.values[row]?.manualImg10].filter{ $0 != ""}
                            )
    }
    
    //레시피 리스트 가져옴
    func getRecipeData(Ingredients:String? = nil, page:Int = 1, size:Int = 5){
        
        var urlKorString = "http://inndiary.xyz/api/v1/search/find-only?page=\(page)&size=\(size)"
        if let search = Ingredients, search != "" {
            urlKorString += "&name=\(search)"
        }
        let urlString = urlKorString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: urlString) else {return}
//        let request = URLRequest(url:url)
//        request.add
        let session = URLSession(configuration:.default)
        let task = session.dataTask(with: url){ (data, response, error) in
            
            if error != nil{
                print(error!)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(RCP.self, from: data!)
                guard let searchCount = decodedData.meta.total_count, searchCount != 0 else {

                    self.showToast(message: "검색결과가 없습니다")
                    print("total count: \(decodedData.meta.total_count), value:\(decodedData.values.count)")
                    return
                }
                
                self.recipePage += 1
                self.currentPage += 1
                //불러온 데이터가 없는경우 값을 할당
                if(self.recipeData == nil){
                    self.recipeData = decodedData
                }
                //불러온 데이터가 이미 있는 경우 배열에 append
                else{
                    self.recipeData?.meta = decodedData.meta
                    self.recipeData?.values.append(contentsOf:decodedData.values)
                    //self.recipeData?.COOKRCP01.RESULT = decodedData.COOKRCP01.RESULT
                }
                
                DispatchQueue.main.async{
                    self.mainTableView.reloadData()
                }

            }catch{
                
                print("Can not load recipe Data")
                print(error)
                self.showToast(message: "검색결과가 없습니다")
            }

        }
        task.resume()
        
    }

    //데이터가 로드되기 전 스크롤링으로 마지막 인덱스에 여러번 도달하면 같은데이터를 여러번 요청하게되는 버그가 발생@@
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){

        //index는 0부터 시작하므로 size - 1
        if indexPath.row == currentPage * (recipeSize-1) {
            getRecipeData(Ingredients:keyword, page: recipePage, size: recipeSize)
        }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

         self.view.endEditing(true)
   }
    
    //레시피 검색, 주어진 키워드로 레시피를 가져온다
    func SearchRecipe(keyword:String?){
        
        //텍스트를 입력한 경우 검색 키워드 저장
        if let search = keyword, search != "" {
            print("not nil: \(search)")
            self.keyword = search
        }
        //검색하지 않은 경우 검색 키워드를 비움
        else{
            self.keyword = nil
        }
        
        //테이블뷰 cell이 생성되었을 때 테이블뷰를 최상단으로 이동
        if self.recipeData != nil {
            let indexPath = IndexPath(row: 0, section: 0)
            mainTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
        //키보드 내리기
        view.endEditing(true)

        self.recipeData = nil
        getRecipeData(Ingredients: keyword)
    }
    
    
    //키보드에 Done 툴바 생성
    func setupTextFields() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                         target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        searchField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    func initailizeLikeReciper(){
        
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        
        //해당 Entity값 모두 삭제하기
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Like")
        do{
            let result = try context.fetch(fetchRequest)
            
            //모든데이터 삭제
            result.forEach{ item in
                context.delete(item)
            }
            
            //영구저장소에 반영
            if context.hasChanges{
                do{
                    try context.save()
                    print("Deleted Data Saved")
                } catch{
                    print(error)
                }
            }

            //좋아요한 레시피 목록 가져오기
            let urlString = "http://inndiary.xyz/api/v1/favorites/give/user?uid=\(uid)"
            let url = URL(string:urlString)
            
            URLSession.shared.dataTask(with:url!){ (data, result, error) in
                
                guard let data = data else {return}
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                    
                    let favoriteRecipes = json["favoriteRecipes"] as! [Any]
                    
                    //서버에서 받은 모든 seq리스트를 로컬저장소에 저장
                    favoriteRecipes.forEach{ item in
                        guard let object = item as? [String:Any] else {return}
                        
                        //리턴값이 Int이므로 Int->String 형변환
                        let seq = String(object["recipe_seq"] as! Int)
                        NSEntityDescription.insertNewObject(forEntityName: "Like", into: self.context).setValue(seq, forKey: "recipe_seq")
                    }
                    //context변경사항을 영구저장소에 저장
                    if self.context.hasChanges{
                        
                        do{
                            try self.context.save()
                            print("Added Data Saved")
                        } catch{
                            print(error)
                        }
                    }
                    
                }
            }.resume()
        }
        catch{
            print(error)
        }
    }
 
    func getLikeRecipes(){
        
        
        
        
    }
}

extension Bundle {
    
    var Food_Recipe_API_Key: String{
        guard let file = self.path(forResource: "APIKeys", ofType: "plist") else{ return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        guard let id = resource["Food_Recipe_API"] as? String else {
            fatalError("Food Recipe API Key Not Found")
        }
        
        return id
    }
}


