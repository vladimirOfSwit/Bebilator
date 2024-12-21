//
//  UIView+Extension.swift
//  Bebilator
//
//  Created by Vladimir Savic on 26.7.23..
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    
}

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
}

extension UITextField {
    func leftImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: imageWidth, height: frame.height)
        imageView.contentMode = .left
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(imageView)
        leftView = containerView
        leftViewMode = .always
    }
    
    func setBottomBorderOnlyWith(color: CGColor) {
        self.borderStyle = .none
        self.layer.masksToBounds = false
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func isError(baseColor: CGColor, numberOfShakes shakes: Float, revert: Bool) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
        animation.fromValue = baseColor
        animation.toValue = UIColor.red.cgColor
        animation.duration = 0.4
        if revert {
            animation.autoreverses = true
        } else {
            animation.autoreverses = false
        }
        self.layer.add(animation, forKey: "")
        
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert {
            shake.autoreverses = true
        } else {
            shake.autoreverses = false
        }
        shake.fromValue = NSValue(cgPoint: CGPoint(x:self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(shake, forKey: "position")
    }
    
    func addShadowAndRoundedCorners(color: UIColor?) {
        layer.masksToBounds = false
        layer.shadowRadius = 2.0
        layer.shadowColor = color?.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.cornerRadius = 7
        layer.borderColor = color?.cgColor
        layer.borderWidth = 1.5
        self.clipsToBounds = true
    }
    
    func validateGenderTextfield(isEligible: (String) -> Bool) -> Bool {
        guard let text = self.text, !text.isEmpty, text != Constants.TEXTFIELD_PLACEHOLDER else {
            self.text = ""
            self.placeholder = "Polje ne može biti prazno."
            self.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 4, revert: true)
            return false
        }
        if !isEligible(text) {
            self.text = ""
            self.placeholder = "Minimum 18. godina"
            self.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 4, revert: true)
            return false
        }
        return true
    }
    
    func editPlaceholderFont(_ placeHolderText: String, fontSize: CGFloat) {
        if let currentFont = self.font {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: currentFont.withSize(fontSize)
            ]
            self.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: attributes)
        }
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        var hexColor = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        if hexColor.count == 6 {
            hexColor.append("FF") // Append alpha value if missing
        }
        
        guard hexColor.count == 8 else { return nil }
        
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
            
            self.init(red: r, green: g, blue: b, alpha: a)
            return
        }
        return nil
    }
}

extension Date {
    public func addYear(n: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .year, value: n, to: self)!
    }
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: self)
    }
}

extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case hasOnboarded
        
    }
    var hasOnboarded: Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }
}

extension UIImage {
    class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        
        let frameCount = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        
        for i in 0..<frameCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            }
        }
        return UIImage.animatedImage(with: images, duration: 5.0)
    }
}

extension UIDatePicker {
    func applyGradientToSelection() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.blue.cgColor,
            UIColor.purple.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        let selectionBarHeight: CGFloat = 40
        let selectionBarFrame = CGRect(x: 0, y: self.bounds.size.height / 2 - selectionBarHeight / 2, width: self.bounds.size.width, height: selectionBarHeight)
        gradientLayer.frame = selectionBarFrame
        
        if let selectionView = self.subviews.first?.subviews.first(where: { $0.frame.height <= 40 }) {
            gradientLayer.frame = selectionView.bounds
            self.layer.addSublayer(gradientLayer)
        }
    }
}

extension String {
    func toDate() -> Date? {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd-MM-yyyy"
       return dateFormatter.date (from: self)
    }
}
