//
//  BaseViewController.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - UI Components
    let backgroundImageView = UIImageView()
    let overlayDimmingLayer = UIView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundAppearance()
        configureNavigationBarAppearance()
    }
    
    // MARK: - Configuration Methods
    func configureBackgroundAppearance() {
        // Background image
        backgroundImageView.image = UIImage(named: "backgroundImage")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        // Dimming overlay
        overlayDimmingLayer.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlayDimmingLayer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayDimmingLayer)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayDimmingLayer.topAnchor.constraint(equalTo: view.topAnchor),
            overlayDimmingLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayDimmingLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayDimmingLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureNavigationBarAppearance() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    func installCustomBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        backButton.setImage(createBackArrowImage(), for: .normal)
        backButton.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)
        backButton.tintColor = .white
        
        let backBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    func createBackArrowImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 24))
        return renderer.image { context in
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 18, y: 4))
            path.addLine(to: CGPoint(x: 8, y: 12))
            path.addLine(to: CGPoint(x: 18, y: 20))
            
            UIColor.white.setStroke()
            path.lineWidth = 2.5
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            path.stroke()
        }.withRenderingMode(.alwaysTemplate)
    }
    
    @objc func handleBackButtonTap() {
        navigationController?.popViewController(animated: true)
    }
}

