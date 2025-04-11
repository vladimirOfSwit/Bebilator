//
//  PreviousScoresViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 24.10.24..
//
import Foundation
import UIKit

class PreviousScoresViewController: UIViewController {
    let tableView = UITableView()
    let viewModel = PreviousScoresViewModel()
    var previousScores: [PreviousScore] = []
    let headerView = ScoresHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        previousScores = viewModel.getFormattedPreviousScores()
        tableView.reloadData()
    }
    
    private func setupViews() {
        navigationItem.title = NSLocalizedString("PREVIOUS SCORES", comment: "navigation bar title on Previous Scores screen")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PreviousScoreCell.self, forCellReuseIdentifier: "PreviousScoreTableViewCell")
        previousScores = viewModel.getFormattedPreviousScores()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let deleteButton = UIButton(type: .system)
        deleteButton.backgroundColor = UIColor(hex: "#7B81BE")
        deleteButton.setTitle("🗑", for: .normal)
        deleteButton.tintColor = .white
        deleteButton.cornerRadius = 30
        deleteButton.clipsToBounds = true
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(clearAllPreviousScores), for: .touchUpInside)
        
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 60),
            deleteButton.heightAnchor.constraint(equalToConstant: 60),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
        deleteButton.layer.shadowColor = UIColor.black.cgColor
        deleteButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        deleteButton.layer.shadowOpacity = 0.3
        deleteButton.layer.shadowRadius = 4
    }
    
    @objc func clearAllPreviousScores() {
        print("clear all button")
        if !previousScores.isEmpty {
            let confirmationAlert = UIAlertController(
                title: NSLocalizedString("Info", comment: "info title regarding the deletion of all previous scores entries saved"),
                message: NSLocalizedString("Are you sure you want to delete all previous results?", comment: "message in the alert regarding the deletion of previous results"),
                preferredStyle: .alert)
            confirmationAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel button to cancel the alert"), style: .cancel, handler: nil))
            confirmationAlert.addAction(UIAlertAction(title: NSLocalizedString("Delete all", comment: "delete button to delete all the previous scores"), style: .destructive, handler: { _ in
                self.viewModel.clearPreviousScores()
                self.previousScores = self.viewModel.getFormattedPreviousScores()
                self.tableView.reloadData()
                
                let successAlert = UIAlertController(
                    title: NSLocalizedString("Info", comment: "info title regarding the deletion of all previous scores entries saved"),
                    message: NSLocalizedString("All previous scores have been deleted.", comment: "message confirming all previous scores have been deleted."),
                    preferredStyle: .alert
                )
                successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(successAlert, animated: true, completion: nil)
            }))
            present(confirmationAlert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Info", comment: "info title regarding the deletion of all previous scores entries saved"), message: NSLocalizedString("All the results have already been deleted.", comment: "info message informing the user that the table is empty already."), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
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
        let color = indexPath.row % 2 == 0 ? UIColor(hex: "#FFFFFF") : UIColor(hex: "#F6F5F0")
        cell.configure(with: score, backgroundColor: color)
        print("Score gender is: \(score.gender)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.rowHeight
    }
}
