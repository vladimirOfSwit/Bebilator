import UIKit



class GradientPageControl: UIPageControl {

    // Now these are safely unwrapped and won’t cause EXC_BAD_ACCESS
    var startColor: UIColor = UIColor(hex: "#6B92E5") // ✅ Works
    var endColor: UIColor = UIColor(hex: "#F88AB0")   // ✅ Works
    //var badColor: UIColor = UIColor(hex: "garbage")  

    override func draw(_ rect: CGRect) {
        backgroundColor = .clear
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        for (index, subview) in subviews.enumerated() {
            let dotRect = subview.frame.insetBy(dx: (subview.frame.width - 8) / 2, dy: (subview.frame.height - 8) / 2)
            
            if index == currentPage {
                // Active dot with gradient
                let path = UIBezierPath(ovalIn: dotRect)
                context.saveGState()
                path.addClip()
                
                let colors = [startColor.cgColor, endColor.cgColor] as CFArray
                guard let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: [0.0, 1.0]) else { return }
                context.drawLinearGradient(gradient, start: CGPoint(x: dotRect.minX, y: dotRect.midY), end: CGPoint(x: dotRect.maxX, y: dotRect.midY), options: [])
                
                context.restoreGState()
            } else {
                // Inactive dot
                let path = UIBezierPath(ovalIn: dotRect)
                UIColor.lightGray.setFill()
                path.fill()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        setNeedsDisplay()
    }
}
