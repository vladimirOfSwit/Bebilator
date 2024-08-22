//
//  ResultsViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 30.11.23..
//
import UIKit


class ResultsViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var repeatOutlet: UIButton!
    
    var genderResult = ""
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
 
        if genderResult == "boy" {
            loadGif(name: "boy")
        } else {
            loadGif(name: "girl")
        }
    }
    
    @IBAction func repeatButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func loadGif(name: String) {
        guard let gifPath = Bundle.main.path(forResource: name, ofType: "gif") else {
            return
        }

        guard let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath)) else {
            return
        }

        guard let gifImage = UIImage.gifImageWithData(gifData) else {
            return
        }
        
        self.gifImageView.image = gifImage
    }
}
