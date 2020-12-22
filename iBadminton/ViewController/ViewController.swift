//
//  ViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/24.
//

import UIKit
import FirebaseAuth
import Lottie
import CarLensCollectionViewLayout
import PKHUD

//import LineSDK

class ViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var homePageCollection: UICollectionView!
    
    private var height: CGFloat?
    
    var events: [Event] = []
    var team: [Team] = []
    var event: Event?
    var count: Int = 0
    var joinMember: [String] = []
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.animate()
        })
    }
    
    private func setupView() {
        homePageCollection.backgroundColor = UIColor.maxColor(with: .mainBlue)
        homePageCollection.register(HomePageCollectionViewCell.self,
                                    forCellWithReuseIdentifier: HomePageCollectionViewCell.identifier)
        homePageCollection.showsHorizontalScrollIndicator = false
        homePageCollection.collectionViewLayout = CarLensCollectionViewLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            
            guard let nextVC = segue.destination as? DetailViewController else {
                print("next view controller is nil")
                return
            }
            
            nextVC.detailEvent = event
        }
    }
    
    //  Launch Screen 動畫設定
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.image = UIImage(named: "i badminton")
        return imageView
    }()
    
    private func animate() {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 2
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            self.imageView.frame = CGRect(
                x: -(diffX / 2),
                y: diffY / 2,
                width: size,
                height: size
            )
        })
        UIView.animate(withDuration: 1.5, animations: {
            self.imageView.alpha = 0
        }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.imageView.removeFromSuperview()
                })
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 隱藏 navigation
        self.navigationController?.isNavigationBarHidden = true
        FireBaseManager.shared.listen(collectionName: .event) {
            self.readEvent()
        }
        setupView()
        view.addSubview(imageView)
        
    }
    
    func readEvent() {
        FireBaseManager.shared.read(collectionName: .event, dataType: Event.self) { (result) in
            switch result {
            case .success(let event):
                self.events = event
                self.homePageCollection.reloadData()
            case .failure(let error): print("======== Home Page Set Data \(error.localizedDescription)=========")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homePageCollection.reloadData()
    }
    
    //  判斷有沒有登入後加入活動或是跳出登入畫面
    @objc func homeJoinButton(_ sender: UIButton) {
        FireBaseManager.shared.checkLogin { uid in
            if uid == nil {
                if #available(iOS 13.0, *) {
                    let signInPage = self.storyboard?.instantiateViewController(identifier: "SignInViewController")
                    self.present(signInPage!, animated: true, completion: nil)
                }
            } else {
                let eventId =  self.events[sender.tag].eventID
                let doc = FireBaseManager.shared.getCollection(name: .event).document(eventId)
                doc.getDocument { (document, _) in
                    if let document = document {
                        guard let join = document["joinID"] as? [String] else { return }
                        
                        if join.contains(uid!) {
                            HUD.flash(.labeledError(title: "哎呀！", subtitle: "你加入過這個活動囉！"), delay: 1.3)
                            
                        } else {
                            FireBaseManager.shared.joinEvent(userId: uid!, event: eventId)
                            HUD.flash(.labeledSuccess(title: "Success!", subtitle: "加入成功記得去打球喔！"), delay: 1.3)
                        }
                    }
                }
            }
        }
    }
    
    func getLack(docId: String) {
        let doc = FireBaseManager.shared.getCollection(name: .event).document(docId)
        doc.getDocument { (result, _) in
            
            let data = result?.data()
            
            self.count = data?["lackCount"] as? Int ?? 0
            self.joinMember.append(contentsOf: data?["joinID"] as? [String] ?? [])
            
            self.homePageCollection.reloadData()
        }
    }
    
    func readTeamRating(teamID: String, handler: @escaping (Team) -> Void) {
        // MARK: 這要改成讀裡面的 teamID
        let docRef = FireBaseManager.shared.getCollection(name: .team).whereField("teamID", isEqualTo: teamID)
        docRef.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                print(error)
            } else {
                
                for document in querySnapshot!.documents {
                    
                    guard let data = try? document.data(as: Team.self) else {
                        print("Team decod error ")
                        return
                    }
                    
                    handler(data)
                }
            }
        }
    }
    
    var animationView: UIView = {
        var animationView = AnimationView()
        animationView = .init(name: "lottie-cat")
        animationView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    func setLaunchText() {
        let image: UIImageView = {
            let image = UIImageView()
            image.contentMode = .scaleAspectFit
            image.image = UIImage(named: "noEvent")
            return image
        }()
        image.translatesAutoresizingMaskIntoConstraints = false
        animationView.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: animationView.centerXAnchor),
            image.topAnchor.constraint(equalTo: animationView.topAnchor, constant: 60),
            image.leadingAnchor.constraint(equalTo: animationView.leadingAnchor, constant: 30),
            image.trailingAnchor.constraint(equalTo: animationView.trailingAnchor, constant: -30)
        ])
    }
    
    // MARK: 監聽活動狀態 status 變成 false不顯示
    // 感覺一開始拿的時候就直接拿 true就好，然後監聽整個 team
    func listenEvent() {
        let collection = FireBaseManager.shared.getCollection(name: .event)
        collection.whereField("status", isEqualTo: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if events.isEmpty {
            homePageCollection.backgroundView = animationView
            setLaunchText()
            
        } else {
            homePageCollection.backgroundView = nil
        }
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomePageCollectionViewCell.identifier,
                for: indexPath) as? HomePageCollectionViewCell else { return UICollectionViewCell() }
        cell.layoutCell(event: events[indexPath.row])
        cell.join.tag = indexPath.row
        //        cell.lackCount.text = "\(count - joinMember.count)"
        //        readTeamRating(teamID: events[indexPath.row].teamName) { (data) in
        //            cell.getTeamRating(data: data)
        //        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        event = events[indexPath.row]
        performSegue(withIdentifier: "showDetailSegue", sender: nil)
    }
}

//extension ViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let screenWidth = UIScreen.main.bounds.size.width - 20
//        let height = UIScreen.main.bounds.size.height * 0.5
//
//        return CGSize(width: screenWidth, height: height)
//    }
//}

extension UIView {
    func setShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 1, height: 3)
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 1
    }
}
