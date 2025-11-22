//
//  ModeSelectionViewController.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

class ModeSelectionViewController: BaseViewController {
    
    // MARK: - UI Components
    let titleLabel = UILabel()
    let classicModeButton = UIButton(type: .system)
    let advancedModeButton = UIButton(type: .system)
    let classicDescriptionLabel = UILabel()
    let advancedDescriptionLabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
        installCustomBackButton()
        applyAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - UI Configuration
    func configureUIElements() {
        configureTitleLabel()
        configureModeButtons()
        configureDescriptionLabels()
        establishConstraints()
    }
    
    func configureTitleLabel() {
        titleLabel.text = ""
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    func configureModeButtons() {
        // Classic Mode Button
        classicModeButton.setTitle("Classic Iteration", for: .normal)
        classicModeButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        classicModeButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.86, alpha: 1.0)
        classicModeButton.setTitleColor(.white, for: .normal)
        classicModeButton.layer.cornerRadius = 20
        classicModeButton.translatesAutoresizingMaskIntoConstraints = false
        classicModeButton.applyElegantShadow(radius: 10)
        classicModeButton.enableSpringAnimation()
        classicModeButton.addTarget(self, action: #selector(handleClassicModeTap), for: .touchUpInside)
        view.addSubview(classicModeButton)
        
        // Advanced Mode Button
        advancedModeButton.setTitle("Enigmatic Iteration", for: .normal)
        advancedModeButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        advancedModeButton.backgroundColor = UIColor(red: 0.8, green: 0.3, blue: 0.4, alpha: 1.0)
        advancedModeButton.setTitleColor(.white, for: .normal)
        advancedModeButton.layer.cornerRadius = 20
        advancedModeButton.translatesAutoresizingMaskIntoConstraints = false
        advancedModeButton.applyElegantShadow(radius: 10)
        advancedModeButton.enableSpringAnimation()
        advancedModeButton.addTarget(self, action: #selector(handleAdvancedModeTap), for: .touchUpInside)
        view.addSubview(advancedModeButton)
    }
    
    func configureDescriptionLabels() {
        // Classic Description
        classicDescriptionLabel.text = "Deduce a tile from singular suit (1-9)\nReceive \"Higher\" or \"Lower\" hints"
        classicDescriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        classicDescriptionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        classicDescriptionLabel.textAlignment = .center
        classicDescriptionLabel.numberOfLines = 0
        classicDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(classicDescriptionLabel)
        
        // Advanced Description
        advancedDescriptionLabel.text = "Deduce from triad suits (27 tiles)\nIntricate clues: suit & numerical concordance"
        advancedDescriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        advancedDescriptionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        advancedDescriptionLabel.textAlignment = .center
        advancedDescriptionLabel.numberOfLines = 0
        advancedDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(advancedDescriptionLabel)
    }
    
    
    func establishConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Classic Button
            classicModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            classicModeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            classicModeButton.widthAnchor.constraint(equalToConstant: 300),
            classicModeButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Classic Description
            classicDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            classicDescriptionLabel.topAnchor.constraint(equalTo: classicModeButton.bottomAnchor, constant: 12),
            classicDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            classicDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Advanced Button
            advancedModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            advancedModeButton.topAnchor.constraint(equalTo: classicDescriptionLabel.bottomAnchor, constant: 50),
            advancedModeButton.widthAnchor.constraint(equalToConstant: 300),
            advancedModeButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Advanced Description
            advancedDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            advancedDescriptionLabel.topAnchor.constraint(equalTo: advancedModeButton.bottomAnchor, constant: 12),
            advancedDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            advancedDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
    // MARK: - Animations
    func applyAnimations() {
        titleLabel.animateFadeIn(duration: 0.6)
        
        classicModeButton.alpha = 0
        classicDescriptionLabel.alpha = 0
        advancedModeButton.alpha = 0
        advancedDescriptionLabel.alpha = 0
        
        UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseOut) {
            self.classicModeButton.alpha = 1
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.3, options: .curveEaseOut) {
            self.classicDescriptionLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.4, options: .curveEaseOut) {
            self.advancedModeButton.alpha = 1
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.5, options: .curveEaseOut) {
            self.advancedDescriptionLabel.alpha = 1
        }
    }
    
    // MARK: - Actions
    @objc func handleClassicModeTap() {
        let classicGameVC = ClassicGameViewController()
        navigationController?.pushViewController(classicGameVC, animated: true)
    }
    
    @objc func handleAdvancedModeTap() {
        let advancedGameVC = AdvVC()
        navigationController?.pushViewController(advancedGameVC, animated: true)
    }
}

