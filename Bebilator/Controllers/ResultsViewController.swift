//
//  ResultsViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 30.11.23..
//
import UIKit


class ResultsViewController: UIViewController {
    
    var genderResult = ""
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    @IBOutlet weak var repeatOutlet: UIButton!
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
    
        if genderResult == "boy" {
            loadGif(name: "boy")
            
        } else {
            loadGif(name: "girl")
           
        }
        
        
        
        

        // Set the loaded GIF image to the UIImageView
        
        

      
    }
    
    @IBAction func repeatButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    func loadGif(name: String) {
        guard let gifPath = Bundle.main.path(forResource: name, ofType: "gif") else {
            print("Failed to find the GIF image.")
            return
        }

        guard let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath)) else {
            print("Failed to load the GIF image data.")
            return
        }

        guard let gifImage = UIImage.gifImageWithData(gifData) else {
            print("Failed to create the GIF image.")
            return
        }
        
        self.gifImageView.image = gifImage
    }
}
