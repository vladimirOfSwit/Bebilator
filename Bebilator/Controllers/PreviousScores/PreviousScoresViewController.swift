        //
        //  PreviousScoresViewController.swift
        //  Bebilator
        //
        //  Created by Vladimir Savic on 24.10.24..
        //
        import Foundation
        import UIKit

        class PreviousScoresViewController: UIViewController {
            @IBOutlet weak var tableView: UITableView!
            
            let viewModel = PreviousScoresViewModel()
            var previousScores: [(nText: String, result: String)] = []
            
            override func viewDidLoad() {
                super.viewDidLoad()
                previousScores = viewModel.getFormattedPreviousScores()
                tableView.delegate = self
                tableView.dataSource = self
                tableView.reloadData()
            }
            
        }

        extension PreviousScoresViewController: UITableViewDataSource, UITableViewDelegate {
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return previousScores.count
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath)
                let score = previousScores[indexPath.row]
                cell.textLabel?.text = "Date: \(score.nText), Result: \(score.result)"
                return cell
            }
            
            
        }
