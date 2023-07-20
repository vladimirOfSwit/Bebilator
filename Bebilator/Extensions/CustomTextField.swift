//
//  CustomTextField.swift
//  Bebilator
//
//  Created by Vladimir Savic on 10.10.23..
//

//import UIKit
//
//class CustomTextField: UITextField {
//    
//    var imageView: UIImageView = UIImageView()
//    
//    var image: UIImage? {
//        didSet {
//            imageView.image = image
//        }
//    }
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.borderStyle = .roundedRect
//        setupImageView()
//    }
//    
//    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//        let bounds = self.bounds
//        
//        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = bounds
//        maskLayer.path = maskPath.cgPath
//        
//        self.layer.mask = maskLayer
//        
//        let frameLayer = CAShapeLayer()
//        frameLayer.frame = bounds
//        frameLayer.path = maskPath.cgPath
//        frameLayer.strokeColor = UIColor.darkGray.cgColor
//        frameLayer.fillColor = UIColor.init(red: 247, green: 247, blue: 247, alpha: 0).cgColor
//        
//        self.layer.addSublayer(frameLayer)
//        
//    }
//    
//    func setupImageView() {
//        imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 35, height: 25))
//        imageView.image = image
//        imageView.contentMode = .scaleAspectFit
//        self.leftView = imageView
//        self.leftViewMode = .always
//    }
//    
//    
//    func roundTopCornersRadius(radius: CGFloat) {
//        roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight], radius: radius)
//    }
//    
//    func roundBottomCornerRadius(radius: CGFloat) {
//        roundCorners(corners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius: radius)
//    }
//    
//    
//}
