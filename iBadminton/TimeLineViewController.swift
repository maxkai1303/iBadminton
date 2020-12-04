//
//  TimeLineViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/2.
//

import UIKit
import ISTimeline

class TimeLineViewController: UIViewController {
    
//    var lineTitle: String?
//    var lineDescription: String?
//    var pointColor: UIColor
//    var lineColor: UIColor
//    var touchUpInside: Optional<(_ point:ISPoint) -> Void> = nil
//    var fill: Bool
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        
    }
    
    func setView() {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let frame = CGRect(x: 0.0, y: 20.0, width: screenWidth, height: screenHeight)
        let timeline = ISTimeline(frame: frame)
        
        timeline.backgroundColor = UIColor(named: "MainBlue")
        timeline.bubbleColor = .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        timeline.titleColor = UIColor(named: "MainBlue")!
        timeline.descriptionColor = .lightGray
        timeline.pointDiameter = 7.0
        timeline.lineWidth = 2.0
        timeline.bubbleRadius = 0.0
        
        self.view.addSubview(timeline)
        
        let fake = FakeData.pointsData()

        timeline.contentInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        timeline.points = fake
//    }
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
