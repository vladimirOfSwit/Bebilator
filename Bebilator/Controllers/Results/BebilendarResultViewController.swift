//
//  BebilendarViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.11.24..
//

import Foundation
import UIKit

class BebilendarResultViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var switchingPeriods: [(year: Int, month: Int, day: Int, gender: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}
extension BebilendarResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
    }
}
extension BebilendarResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return switchingPeriods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let period = switchingPeriods[indexPath.row]
        cell.textLabel?.text = "Year: \(period.year) Month: \(period.month), Day: \(period.day), gender: \(period.gender)"
        return cell
    }
}
