//
//  TeamRatingViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/7.
//

import UIKit

class TeamRatingViewController: UIViewController, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension TeamRatingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "teamRatingTableViewCell", for: indexPath)
                as? TeamRatingTableViewCell else { return UITableViewCell() }
        return cell
    }
}
