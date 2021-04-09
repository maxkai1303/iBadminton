//
//  TimeLineViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/2.
//

import UIKit
import ISTimeline
import Firebase
import FirebaseFirestoreSwift

class TimeLineViewController: UIViewController {
    
    var timeline = ISTimeline()
    
    var data: [TeamPoint] = []
    var teamId: String = ""
    var teamName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        listenNew()
    }
    
    func listenNew() {
        
        FireBaseManager.shared.listen(collectionName: .team) {
            
            self.readPoint(dataType: TeamPoint.self) { (result) in
                
                switch result {
                
                case.success(let data):
                    
                    self.data = data.sorted (by: { (first, second) -> Bool in
                        
                        return first.time.dateValue() > second.time.dateValue()
                    })
                    
                    print("data: ", self.data)
                    self.setData()
                    
                case.failure(let error): print("===== Get Error \(error) ======")
                }
            }
        }
    }
    
    func readPoint <T: Codable> (dataType: T.Type, handler: @escaping (Result<[T]>) -> Void) {
        
        let collection = FireBaseManager.shared.fireDb.collection("Team").document(teamId).collection("TeamPoint")
        
        collection.getDocuments(completion: { (querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot else {
                
                handler(.failure(error!))
                return
            }
            
            self.decode(dataType, documents: querySnapshot.documents) { (result) in
                
                switch result {
                
                case .success(let data):
                    handler(.success(data))
                    
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        })
    }
    
    func decode<T: Codable>(_ dataType: T.Type, documents: [QueryDocumentSnapshot], handler: @escaping (Result<[T]>) -> Void) {
        
        var datas: [T] = []
        for document in documents {
            
            guard let data = try? document.data(as: dataType) else {
                
                handler(.failure(FirebaseError.decode))
                return
                
            }
            datas.append(data)
        }
        handler(.success(datas))
    }
    
    func setView() {
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        let frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight)
        timeline.frame = frame
        
        timeline.backgroundColor = UIColor(named: "MainBlue")
        timeline.bubbleColor = .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        timeline.titleColor = UIColor(named: "MainBlue")!
        timeline.descriptionColor = .lightGray
        timeline.pointDiameter = 7.0
        timeline.lineWidth = 2.0
        timeline.bubbleRadius = 0.0
        
        self.view.addSubview(timeline)
    }
    
    func setData() {
        
        let data = pointsData()
        
        timeline.contentInset = UIEdgeInsets(top: 100.0, left: 20.0, bottom: 20.0, right: 20.0)
        timeline.points = data
        
    }
    
    func pointsData() -> [ISPoint] {
        
        let touchAction = { (point: ISPoint) in
            
            print("point \(point.title)")
            
        }
        
        var myPoint: [ISPoint] = []
        
        for item in self.data {
            
            let point =
                ISPoint(title: item.content,
                        description: FireBaseManager.shared.timeStampToStringDetail(item.time),
                        pointColor: UIColor(named: "LightBlue")!,
                        lineColor: UIColor.yellow,
                        touchUpInside: touchAction,
                        fill: true
                )
            
            print("point data: ", point)
            myPoint.append(point)
            
        }
        
        print("==================\(myPoint)=============")
        print("myPoing data: ", myPoint)
        
        return myPoint
        
    }
}

/*
 var title:String shown in the bubble
 var description:String? shown below the bubble
 var pointColor:UIColor the color of each point in the line
 var lineColor:UIColor the color of the line after a point
 var touchUpInside:Optional<(_ point:ISPoint) -> Void> a callback, which is triggered after a touch inside a bubble
 var fill:Bool fills the point in the line (default: false)
 */
