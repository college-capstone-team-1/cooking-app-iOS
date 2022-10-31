//
//  ViewController.swift
//  EcoRecipe
//
//  Created by 미미밍 on 2022/10/05.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet var searchField: UITextField!
    @IBOutlet weak var mainTableView: UITableView!
    
    struct RCP:Codable{
        var COOKRCP01:CookRCP01
    }
    
    struct CookRCP01:Codable{
        var total_count:String?
        var row:[Row?] = [Row]()    //검색결과가 없을 때 리턴되지 않음
        var RESULT:Result?
        
        init(from decoder: Decoder) throws{
            let values = try decoder.container(keyedBy: CodingKeys.self)
            total_count = (try? values.decode(String.self, forKey: .total_count)) ?? ""
            RESULT = try? values.decodeIfPresent(Result.self, forKey: .RESULT)
            row = try values.decodeIfPresent([Row?].self, forKey: .row) ?? [nil]

            //self.thumbnailURL = try container.decodeIfPresent(String.self, forKey: .thumnailURL)
        }
    }
    
    struct Row:Codable{
        let RCP_SEQ:String?         //일련번호
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
        let ATT_FILE_NO_MK:String?  //이미지경로(대)
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
        let MANUAL10:String?        //만드는법_10
        let MANUAL_IMG10:String?    //만드는법_이미지_10
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
    
    struct Result:Codable{
        let MSG:String
        let CODE:String
    }
    
    var recipeData:RCP? = nil
    var startIndex:Int = 1
    var endIndex:Int = 5
    private var currentPage = 1
    var keyword:String?

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
        
        return self.recipeData?.COOKRCP01.row.count ?? 0  //페이지당 5개
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCell", for: indexPath) as! MainTableViewCell
        
        cell.rcpName.text = self.recipeData?.COOKRCP01.row[indexPath.row]?.RCP_NM
        
        
        //서버에 값이 없으면 ""을 전달하므로 nil이 아니라 옵셔널("")값이 저장됨
        if let imgString = self.recipeData?.COOKRCP01.row[indexPath.row]?.ATT_FILE_NO_MAIN, imgString != "" {
            DispatchQueue.global().async {
                
                let imgURL = URL(string: self.recipeData?.COOKRCP01.row[indexPath.row]?.ATT_FILE_NO_MAIN! ?? "")
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
        
                            //일련번호
        dest.recipeTuple = (seq:recipeData?.COOKRCP01.row[row]?.RCP_SEQ,
                            //음식 이름
                            name:recipeData?.COOKRCP01.row[row]?.RCP_NM,
                            //조리방식
                            way2:recipeData?.COOKRCP01.row[row]?.RCP_WAY2,
                            //요리종류
                            pat2:recipeData?.COOKRCP01.row[row]?.RCP_PAT2,
                            //중량(1인분)
                            wtg:recipeData?.COOKRCP01.row[row]?.INFO_WGT,
                            //열량(1인분)
                            eng:recipeData?.COOKRCP01.row[row]?.INFO_ENG,
                            //탄수화물
                            car:recipeData?.COOKRCP01.row[row]?.INFO_CAR,
                            //단백질
                            pro:recipeData?.COOKRCP01.row[row]?.INFO_PRO,
                            //지방
                            fat:recipeData?.COOKRCP01.row[row]?.INFO_FAT,
                            //나트륨
                            na:recipeData?.COOKRCP01.row[row]?.INFO_NA,
                            //해쉬태그
                            tag:recipeData?.COOKRCP01.row[row]?.HASH_TAG,
                            //음식 사진
                            img:recipeData?.COOKRCP01.row[row]?.ATT_FILE_NO_MAIN,
                            //음식 재료
                            dtls:recipeData?.COOKRCP01.row[row]?.RCP_PARTS_DTLS?.components(separatedBy: "\n").joined(),
                            //만드는법 배열
                            manual:[recipeData?.COOKRCP01.row[row]?.MANUAL01,recipeData?.COOKRCP01.row[row]?.MANUAL02,recipeData?.COOKRCP01.row[row]?.MANUAL03,recipeData?.COOKRCP01.row[row]?.MANUAL04,recipeData?.COOKRCP01.row[row]?.MANUAL05,recipeData?.COOKRCP01.row[row]?.MANUAL06,recipeData?.COOKRCP01.row[row]?.MANUAL07, recipeData?.COOKRCP01.row[row]?.MANUAL08, recipeData?.COOKRCP01.row[row]?.MANUAL09, recipeData?.COOKRCP01.row[row]?.MANUAL10].filter{ $0 != ""}.map{ Optional($0!.components(separatedBy: "\n").joined())},
                            //만드는법 사진링크 배열
                            manualImg:[recipeData?.COOKRCP01.row[row]?.MANUAL_IMG01, recipeData?.COOKRCP01.row[row]?.MANUAL_IMG02, recipeData?.COOKRCP01.row[row]?.MANUAL_IMG03, recipeData?.COOKRCP01.row[row]?.MANUAL_IMG04, recipeData?.COOKRCP01.row[row]?.MANUAL_IMG05, recipeData?.COOKRCP01.row[row]?.MANUAL_IMG06, recipeData?.COOKRCP01.row[row]?.MANUAL_IMG07, recipeData?.COOKRCP01.row[row]?.MANUAL_IMG08, recipeData?.COOKRCP01.row[row]?.MANUAL_IMG09, recipeData?.COOKRCP01.row[row]?.MANUAL_IMG10].filter{ $0 != ""}
                            )
    }
    
    //레시피 리스트 가져옴
    func getRecipeData(Ingredients:String? = nil, startIndex:Int = 1, endIndex:Int = 5){
        
        var urlKorString = "https://openapi.foodsafetykorea.go.kr/api/aa2b9872939a45888fd3/COOKRCP01/json/\(startIndex)/\(endIndex)"
        
        if let search = Ingredients, search != "" {
            urlKorString += "/RCP_PARTS_DTLS=\(search)"
        }
        
        let urlString = urlKorString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration:.default)
        let task = session.dataTask(with: url){ (data, response, error) in
            
            if error != nil{
                print(error!)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(RCP.self, from: data!)
                
                guard let searchCount = decodedData.COOKRCP01.total_count, searchCount != "0" else {

                    self.showToast(message: "검색결과가 없습니다")
                    print("Message: \(decodedData.COOKRCP01.RESULT?.MSG), CODE: \(decodedData.COOKRCP01.RESULT?.CODE)")
                    return
                }

                self.currentPage = endIndex + 1
                
                //데이터가 없는경우
                if(self.recipeData == nil){
                    self.recipeData = decodedData
                }
                //저장한 데이터가 있는 경우
                else{
                    self.recipeData?.COOKRCP01.total_count = decodedData.COOKRCP01.total_count
                    self.recipeData?.COOKRCP01.row.append(contentsOf:decodedData.COOKRCP01.row)
                    self.recipeData?.COOKRCP01.RESULT = decodedData.COOKRCP01.RESULT
                }
                
                DispatchQueue.main.async{
                    self.mainTableView.reloadData()
                }

            }catch{
                
                print("Can not load recipe Data, check the error msg")
                print(error)
                self.showToast(message: "검색결과가 없습니다")
            }

        }
        task.resume()
        
    }

    //데이터가 로드되기 전 스크롤링으로 마지막 인덱스에 여러번 도달하면 같은데이터를 여러번 요청하게되는 버그가 발생@@
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        //API Start인덱스는 1부터 시작함
        if indexPath.row + 2 == currentPage {
            
            getRecipeData(Ingredients:keyword, startIndex: currentPage, endIndex: currentPage + 4)
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
    
}



