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
            var previousScores: [(mText: String, wText: String, nText: String, result: String)] = []
            let headerView = ScoresHeaderView()
            
            override func viewDidLoad() {
                super.viewDidLoad()
                tableView.register(PreviousScoreCell.self, forCellReuseIdentifier: "PreviousScoreTableViewCell")
                previousScores = viewModel.getFormattedPreviousScores()
                tableView.delegate = self
                tableView.dataSource = self
                tableView.reloadData()
            }
            
        }

        extension PreviousScoresViewController: UITableViewDataSource, UITableViewDelegate {
            func numberOfSections(in tableView: UITableView) -> Int {
                1
            }
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return previousScores.count
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousScoreTableViewCell", for: indexPath) as? PreviousScoreCell else {
                    return UITableViewCell()
                }
                let score = previousScores[indexPath.row]
                cell.configure(with: score.mText, wText: score.wText, gender: score.result, nText: score.nText)
                return cell
            }
            func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                let headerView = ScoresHeaderView()
                return headerView
            }
            func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
                return 30
            }
            
            
        }
