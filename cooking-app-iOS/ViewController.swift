//
//  ViewController.swift
//  EcoRecipe
//
//  Created by 미미밍 on 2022/10/05.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    
    @IBOutlet var searchField: UITextField!
    @IBOutlet weak var mainTableView: UITableView!
    
    struct RCP:Codable{
        var COOKRCP01:CookRCP01
    }
    
    struct CookRCP01:Codable{
        var total_count:String?
        var row:[Row?] = [nil]      //검색결과가 없을 때 리턴되지 않음
        var RESULT:Result?
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
        
        
        //검색바 돋보기이미지 생성 및 배치

        let imageView = UIImageView(frame: CGRect(x: 5, y: 2, width: 25, height: 25))
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "ic_search.png")
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30 , height: 30))
        leftView.addSubview(imageView)
 
        searchField.leftView = leftView
        searchField.leftViewMode = .always
        
    }

    @IBAction func searchBtn(_ sender: Any) {
        
        //텍스트를 입력한 경우 검색 키워드 저장
        if let search = searchField.text, search != "" {
            print("not nil")
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
        
        self.recipeData = nil
        getRecipeData(Ingredients: keyword)
        
       
        
        
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
    
    
    
    func getRecipeData(Ingredients:String? = nil, startIndex:Int = 1, endIndex:Int = 5){
        
        var urlKorString = "https://openapi.foodsafetykorea.go.kr/api/aa2b9872939a45888fd3/COOKRCP01/json/\(startIndex)/\(endIndex)"
        
        if let search = Ingredients {
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
                //print(decodedData)
                
                //생성자로 생성된 배열은 append로 nil값에 데이터를 삽입할 수 있음
                //struct은 구조체 생성 및 내부 구조체 역시 생성되야 하므로 기본 생성자로는 생성불가함 디코딩한 JOSNE값을 직접 넣어줌으로써 초기화하는 과정이 필요
                
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
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        
        //let width = message.count * 15
        
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
            UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0}, completion: {
                (isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
        
    }

}



