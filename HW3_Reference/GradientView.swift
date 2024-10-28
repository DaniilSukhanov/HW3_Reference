//
//  GradientView.swift
//  HW3_Reference
//
//  Created by Даниил Суханов on 26.10.2024.
//

import UIKit
import OSLog

class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()
    private enum UnicKeyPath: String {
        case animationColor
    }
    
    private var colors: [CGColor]?
    private var duration: CFTimeInterval?
    private let logger = Logger(subsystem: "GradientView", category: "UI")
    
    init(colors: [UIColor], duration: CFTimeInterval) {
        super.init(frame: .zero)
        self.colors = colors.compactMap(\.cgColor)
        self.duration = duration
        setupGradient()
        setupAnimation()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        setupAnimation()
    }
    
    private func setupGradient() {
        guard let colors else {
            logger.warning("Colors is nil!")
            return
        }
        
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupAnimation() {
        guard let colors, let duration else {
            logger.warning("Colors or duration is nil!")
            return
        }
        
        gradientLayer.colors = colors
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = colors
        animation.toValue = Array(colors.reversed())
        animation.duration = duration
        animation.autoreverses = true
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: "colorChangeAnimation")
    }
}

