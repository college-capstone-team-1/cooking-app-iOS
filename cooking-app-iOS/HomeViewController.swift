//
//  HomeViewController.swift
//  cooking-app-iOS
//
//  Created by WS on 2022/12/10.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var homeBannerCollectionView: UICollectionView!
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        homeBannerCollectionView.delegate = self
        homeBannerCollectionView.dataSource = self
        
        getRecipeRank()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeData?.values.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = homeBannerCollectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! HomeCollectionViewCell
        
        if let imageUrlString = recipeData?.values[indexPath.row]?.attFileNoMain, imageUrlString != "" {
            
            let imgURL = URL(string: imageUrlString)
            DispatchQueue.global().async {
                
                if let imgData = try? Data(contentsOf: imgURL!){
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: imgData)
                        cell.nameLabel?.text = self.recipeData?.values[indexPath.row]?.rcpNm
                    }
                }
                
            }
        }
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout 상속
    //컬렉션뷰 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: homeBannerCollectionView.frame.size.width  , height:  homeBannerCollectionView.frame.height)
    }
    
    
    func getRecipeRank(){
        
        let url = URL(string:"http://inndiary.xyz/api/v1/recipes/rank")

        URLSession.shared.dataTask(with:url!){ (data, response, error) in

            if error != nil{
                print(error!)
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                let decodedData = try decoder.decode(RCP.self, from: data!)
                
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
                    self.homeBannerCollectionView.reloadData()
                }
            }
            catch{
                print(error)
            }
            
        }.resume()
    }
    
    //segue가 동작하기 전 호출
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let dest = segue.destination as? DetailViewController else {return}
        //index 계산
        let rect = CGRect(origin: homeBannerCollectionView.contentOffset, size: homeBannerCollectionView.bounds.size)
        let point = CGPoint(x: rect.midX, y: rect.midY)
        let collectionViewIndexPath = homeBannerCollectionView.indexPathForItem(at: point)
        guard let row = collectionViewIndexPath?.row else {return}
        
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
    
    
}
