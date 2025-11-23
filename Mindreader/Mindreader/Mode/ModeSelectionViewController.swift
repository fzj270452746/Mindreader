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
    let oracleModeButton = UIButton(type: .system)
    let classicDescriptionLabel = UILabel()
    let advancedDescriptionLabel = UILabel()
    let oracleDescriptionLabel = UILabel()
    
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
        classicModeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        classicModeButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.86, alpha: 1.0)
        classicModeButton.setTitleColor(.white, for: .normal)
        classicModeButton.layer.cornerRadius = 18
        classicModeButton.translatesAutoresizingMaskIntoConstraints = false
        classicModeButton.applyElegantShadow(radius: 10)
        classicModeButton.enableSpringAnimation()
        classicModeButton.addTarget(self, action: #selector(handleClassicModeTap), for: .touchUpInside)
        view.addSubview(classicModeButton)
        
        // Advanced Mode Button
        advancedModeButton.setTitle("Enigmatic Iteration", for: .normal)
        advancedModeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        advancedModeButton.backgroundColor = UIColor(red: 0.8, green: 0.3, blue: 0.4, alpha: 1.0)
        advancedModeButton.setTitleColor(.white, for: .normal)
        advancedModeButton.layer.cornerRadius = 18
        advancedModeButton.translatesAutoresizingMaskIntoConstraints = false
        advancedModeButton.applyElegantShadow(radius: 10)
        advancedModeButton.enableSpringAnimation()
        advancedModeButton.addTarget(self, action: #selector(handleAdvancedModeTap), for: .touchUpInside)
        view.addSubview(advancedModeButton)
        
        // Oracle Mode Button
        oracleModeButton.setTitle("Oracle Mode", for: .normal)
        oracleModeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        oracleModeButton.backgroundColor = UIColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 1.0)
        oracleModeButton.setTitleColor(.white, for: .normal)
        oracleModeButton.layer.cornerRadius = 18
        oracleModeButton.translatesAutoresizingMaskIntoConstraints = false
        oracleModeButton.applyElegantShadow(radius: 10)
        oracleModeButton.enableSpringAnimation()
        oracleModeButton.addTarget(self, action: #selector(handleOracleModeTap), for: .touchUpInside)
        view.addSubview(oracleModeButton)
    }
    
    func configureDescriptionLabels() {
        // Classic Description
        classicDescriptionLabel.text = "Deduce a tile from singular suit (1-9)\nReceive \"Higher\" or \"Lower\" hints"
        classicDescriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        classicDescriptionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        classicDescriptionLabel.textAlignment = .center
        classicDescriptionLabel.numberOfLines = 0
        classicDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(classicDescriptionLabel)
        
        // Advanced Description
        advancedDescriptionLabel.text = "Deduce from triad suits (27 tiles)\nIntricate clues: suit & numerical concordance"
        advancedDescriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        advancedDescriptionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        advancedDescriptionLabel.textAlignment = .center
        advancedDescriptionLabel.numberOfLines = 0
        advancedDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(advancedDescriptionLabel)
        
        // Oracle Description
        oracleDescriptionLabel.text = "AI guesses YOUR tile!\nAnswer questions with YES/NO"
        oracleDescriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        oracleDescriptionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        oracleDescriptionLabel.textAlignment = .center
        oracleDescriptionLabel.numberOfLines = 0
        oracleDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(oracleDescriptionLabel)
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
            classicModeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -130),
            classicModeButton.widthAnchor.constraint(equalToConstant: 280),
            classicModeButton.heightAnchor.constraint(equalToConstant: 54),
            
            // Classic Description
            classicDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            classicDescriptionLabel.topAnchor.constraint(equalTo: classicModeButton.bottomAnchor, constant: 10),
            classicDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            classicDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Advanced Button
            advancedModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            advancedModeButton.topAnchor.constraint(equalTo: classicDescriptionLabel.bottomAnchor, constant: 35),
            advancedModeButton.widthAnchor.constraint(equalToConstant: 280),
            advancedModeButton.heightAnchor.constraint(equalToConstant: 54),
            
            // Advanced Description
            advancedDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            advancedDescriptionLabel.topAnchor.constraint(equalTo: advancedModeButton.bottomAnchor, constant: 10),
            advancedDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            advancedDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Oracle Button
            oracleModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            oracleModeButton.topAnchor.constraint(equalTo: advancedDescriptionLabel.bottomAnchor, constant: 35),
            oracleModeButton.widthAnchor.constraint(equalToConstant: 280),
            oracleModeButton.heightAnchor.constraint(equalToConstant: 54),
            
            // Oracle Description
            oracleDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            oracleDescriptionLabel.topAnchor.constraint(equalTo: oracleModeButton.bottomAnchor, constant: 10),
            oracleDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            oracleDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
    // MARK: - Animations
    func applyAnimations() {
        titleLabel.animateFadeIn(duration: 0.6)
        
        classicModeButton.alpha = 0
        classicDescriptionLabel.alpha = 0
        advancedModeButton.alpha = 0
        advancedDescriptionLabel.alpha = 0
        oracleModeButton.alpha = 0
        oracleDescriptionLabel.alpha = 0
        
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
        
        UIView.animate(withDuration: 0.6, delay: 0.6, options: .curveEaseOut) {
            self.oracleModeButton.alpha = 1
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.7, options: .curveEaseOut) {
            self.oracleDescriptionLabel.alpha = 1
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
    
    @objc func handleOracleModeTap() {
        let oracleGameVC = OracleGameViewController()
        navigationController?.pushViewController(oracleGameVC, animated: true)
    }
}

