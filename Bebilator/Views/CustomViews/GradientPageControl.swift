import UIKit

class GradientPageControl: UIPageControl {

    var startColor: UIColor = UIColor(hex: "#6B92E5")
    var endColor: UIColor = UIColor(hex: "#F88AB0")
    var inactiveColor: UIColor = UIColor.lightGray

    private var dotViews: [UIView] = []
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    override var numberOfPages: Int {
        didSet { setupDots() }
    }

    override var currentPage: Int {
        didSet { updateDots() }
    }

    private func setupDots() {
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()

        for _ in 0..<numberOfPages {
            let dot = UIView()
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.layer.cornerRadius = 5
            dot.clipsToBounds = true
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 10),
                dot.heightAnchor.constraint(equalToConstant: 10)
            ])
            stackView.addArrangedSubview(dot)
            dotViews.append(dot)
        }
        updateDots()
    }

    private func updateDots() {
        for (index, dot) in dotViews.enumerated() {
            dot.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            if index == currentPage {
                applyGradient(to: dot, colors: [startColor.cgColor, endColor.cgColor])
            } else {
                applyGradient(to: dot, colors: [inactiveColor.cgColor, inactiveColor.cgColor])
            }
        }
    }

    private func applyGradient(to view: UIView, colors: [CGColor]) {
        let gradient = CAGradientLayer()
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = view.bounds
        gradient.cornerRadius = view.layer.cornerRadius
        view.layer.insertSublayer(gradient, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        for dot in dotViews {
            dot.layer.sublayers?.forEach {
                if let gradient = $0 as? CAGradientLayer {
                    gradient.frame = dot.bounds
                }
            }
        }
    }
}



