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
    var previousScores: [PreviousScore] = []
    let headerView = ScoresHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        tableView.register(PreviousScoreCell.self, forCellReuseIdentifier: "PreviousScoreTableViewCell")
        previousScores = viewModel.getFormattedPreviousScores()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
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
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
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
                title: "Potvrda",
                message: "Da li ste sigurni da želite da obrišete prethodne rezultate?",
                preferredStyle: .alert)
            confirmationAlert.addAction(UIAlertAction(title: "Otkaži", style: .cancel, handler: nil))
            confirmationAlert.addAction(UIAlertAction(title: "Obriši", style: .destructive, handler: { _ in
                self.viewModel.clearPreviousScores()
                self.previousScores = self.viewModel.getFormattedPreviousScores()
                self.tableView.reloadData()
                
                let successAlert = UIAlertController(
                    title: "Obaveštenje",
                    message: "Prethodni rezultati su obrisani.",
                    preferredStyle: .alert
                )
                successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(successAlert, animated: true, completion: nil)
            }))
            present(confirmationAlert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Obaveštenje", message: "Rezultati su već obrisani.", preferredStyle: .alert)
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
        cell.configure(with: score.mText,
                       wText: score.wText,
                       gender: score.gender,
                       nText: score.nText)
        cell.isUserInteractionEnabled = false
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(hex: "#FFFFFF#")
        } else {
            cell.backgroundColor = UIColor(hex: "#F6F5F0")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ScoresHeaderView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.rowHeight
    }
}
