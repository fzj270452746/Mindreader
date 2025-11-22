//
//  UIButton+Extension.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

extension UIButton {
    
    func applyMahjongButtonStyling(backgroundColor: UIColor, cornerRadius: CGFloat = 16) {
        self.backgroundColor = backgroundColor
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        applyElegantShadow()
    }
    
    func applyGradientStyling(colors: [UIColor], cornerRadius: CGFloat = 16) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        applyElegantShadow()
    }
    
    func applyTileButtonStyling() {
        backgroundColor = UIColor.white.withAlphaComponent(0.95)
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.masksToBounds = true
        applyElegantShadow(opacity: 0.2, radius: 4)
    }
    
    func enableSpringAnimation() {
        addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        addTarget(self, action: #selector(handleTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func handleTouchDown() {
        animateSpringBounce()
    }
    
    @objc private func handleTouchUp() {
        UIView.animate(withDuration: 0.15) {
            self.transform = .identity
        }
    }
}

