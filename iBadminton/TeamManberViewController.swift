//
//  TeamManberViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/18.
//  swiftlint:disable all

import UIKit
import Eureka

class TeamManberViewController: FormViewController {
    
    var team: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
    }
    
    func listenManber() {
        FireBaseManager.shared.listen(collectionName: .team) {
            self.tableView.reloadData()
        }
    }
    
    func setLabel() {
        
        tableView.backgroundColor = UIColor.maxColor(with: .lightBlue)
        
        form +++ Section(header: "成員列表", footer: "成員共 \(team?.teamMenber.count ?? 0)人")
        guard team?.teamMenber != [] else { return }
            for i in team!.teamMenber {
                self.form.last! <<< LabelRow() { row in
                row.title = "\(i)"
            }
        }
        
    }
}
