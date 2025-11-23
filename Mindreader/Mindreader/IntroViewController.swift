//
//  IntroViewController.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

class IntroViewController: UIViewController {
    
    // MARK: - UI Components
    let backgroundImageView = UIImageView()
    let overlayView = UIView()
    let startGameButton = UIButton(type: .system)
    let viewRecordsButton = UIButton(type: .system)
    let instructionsButton = UIButton(type: .system)
    let feedbackButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        configureUIElements()
        configureFeedbackFloatingButton()
        applyAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - UI Configuration
    func configureUIElements() {
        configureBackground()
        configureButtons()
        establishConstraints()
    }
    
    func configureBackground() {
        // Background Image
        backgroundImageView.image = UIImage(named: "backgroundImage")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        // Overlay
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureButtons() {
        // Start Game Button
        startGameButton.setTitle("Commence Gameplay", for: .normal)
        startGameButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        startGameButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.86, alpha: 1.0)
        startGameButton.setTitleColor(.white, for: .normal)
        startGameButton.layer.cornerRadius = 16
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        startGameButton.applyElegantShadow()
        startGameButton.enableSpringAnimation()
        startGameButton.addTarget(self, action: #selector(handleStartGameTap), for: .touchUpInside)
        view.addSubview(startGameButton)
        
        // View Records Button
        viewRecordsButton.setTitle("Chronicle Archive", for: .normal)
        viewRecordsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        viewRecordsButton.backgroundColor = UIColor(red: 0.4, green: 0.3, blue: 0.6, alpha: 1.0)
        viewRecordsButton.setTitleColor(.white, for: .normal)
        viewRecordsButton.layer.cornerRadius = 14
        viewRecordsButton.translatesAutoresizingMaskIntoConstraints = false
        viewRecordsButton.applyElegantShadow()
        viewRecordsButton.enableSpringAnimation()
        viewRecordsButton.addTarget(self, action: #selector(handleViewRecordsTap), for: .touchUpInside)
        view.addSubview(viewRecordsButton)
        
        // Instructions Button
        instructionsButton.setTitle("Gameplay Codex", for: .normal)
        instructionsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        instructionsButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.5, alpha: 1.0)
        instructionsButton.setTitleColor(.white, for: .normal)
        instructionsButton.layer.cornerRadius = 14
        instructionsButton.translatesAutoresizingMaskIntoConstraints = false
        instructionsButton.applyElegantShadow()
        instructionsButton.enableSpringAnimation()
        instructionsButton.addTarget(self, action: #selector(handleInstructionsTap), for: .touchUpInside)
        view.addSubview(instructionsButton)
        
        // Feedback Button
        feedbackButton.setTitle("Feedback & Rating", for: .normal)
        feedbackButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        feedbackButton.backgroundColor = UIColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 1.0)
        feedbackButton.setTitleColor(.white, for: .normal)
        feedbackButton.layer.cornerRadius = 14
        feedbackButton.translatesAutoresizingMaskIntoConstraints = false
        feedbackButton.applyElegantShadow()
        feedbackButton.enableSpringAnimation()
        feedbackButton.addTarget(self, action: #selector(handleFeedbackTap), for: .touchUpInside)
        view.addSubview(feedbackButton)
    }
    
    func establishConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // Start Button
            startGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startGameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            startGameButton.widthAnchor.constraint(equalToConstant: 280),
            startGameButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Records Button
            viewRecordsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewRecordsButton.topAnchor.constraint(equalTo: startGameButton.bottomAnchor, constant: 20),
            viewRecordsButton.widthAnchor.constraint(equalToConstant: 280),
            viewRecordsButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Instructions Button
            instructionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionsButton.topAnchor.constraint(equalTo: viewRecordsButton.bottomAnchor, constant: 16),
            instructionsButton.widthAnchor.constraint(equalToConstant: 280),
            instructionsButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Feedback Button
            feedbackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedbackButton.topAnchor.constraint(equalTo: instructionsButton.bottomAnchor, constant: 16),
            feedbackButton.widthAnchor.constraint(equalToConstant: 280),
            feedbackButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Animations
    func applyAnimations() {
        startGameButton.alpha = 0
        viewRecordsButton.alpha = 0
        instructionsButton.alpha = 0
        feedbackButton.alpha = 0
        
        UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseOut) {
            self.startGameButton.alpha = 1
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.4, options: .curveEaseOut) {
            self.viewRecordsButton.alpha = 1
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.6, options: .curveEaseOut) {
            self.instructionsButton.alpha = 1
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.8, options: .curveEaseOut) {
            self.feedbackButton.alpha = 1
        }
    }
    
    // MARK: - Actions
    @objc func handleStartGameTap() {
        let modeSelectionVC = ModeSelectionViewController()
        navigationController?.pushViewController(modeSelectionVC, animated: true)
    }
    
    @objc func handleViewRecordsTap() {
        let recordsVC = RecordsViewController()
        navigationController?.pushViewController(recordsVC, animated: true)
    }
    
    @objc func handleInstructionsTap() {
        let instructionsVC = InstructionsViewController()
        navigationController?.pushViewController(instructionsVC, animated: true)
    }
    
    @objc func handleFeedbackTap() {
        let feedbackVC = FeedbackViewController()
        navigationController?.pushViewController(feedbackVC, animated: true)
    }
    
    // MARK: - Quick Feedback
    func configureFeedbackFloatingButton() {
        let floatingButton = UIButton(type: .system)
        floatingButton.setTitle("💬", for: .normal)
        floatingButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        floatingButton.backgroundColor = UIColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 0.95)
        floatingButton.layer.cornerRadius = 30
        floatingButton.layer.masksToBounds = false
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.layer.shadowColor = UIColor.black.cgColor
        floatingButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        floatingButton.layer.shadowOpacity = 0.4
        floatingButton.layer.shadowRadius = 10
        floatingButton.addTarget(self, action: #selector(handleQuickFeedbackTap), for: .touchUpInside)
        floatingButton.tag = 9999 // Special tag to identify this button
        view.addSubview(floatingButton)
        
        // Ensure it's on top of everything
        view.bringSubviewToFront(floatingButton)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Add pulse animation after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            floatingButton.animatePulseEffect()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Ensure floating button stays on top
        if let floatingButton = view.viewWithTag(9999) {
            view.bringSubviewToFront(floatingButton)
        }
    }
    
    @objc func handleQuickFeedbackTap() {
        let alertController = UIAlertController(
            title: "Quick Feedback",
            message: "Share your thoughts about the game",
            preferredStyle: .alert
        )
        
        // Add text field
        alertController.addTextField { textField in
            textField.placeholder = "Your feedback here..."
            textField.autocapitalizationType = .sentences
        }
        
        // Submit action
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] _ in
            guard let textField = alertController?.textFields?.first,
                  let feedbackText = textField.text,
                  !feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                self?.showSimpleAlert(title: "Empty Feedback", message: "Please enter your feedback.")
                return
            }
            
            self?.saveFeedback(text: feedbackText)
            self?.showThankYouAnimation()
        }
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func saveFeedback(text: String) {
        let feedback = FeedbackModel(
            uniqueIdentifier: UUID().uuidString,
            rating: 5, // Default rating for quick feedback
            feedbackText: text,
            timestampDate: Date()
        )
        
        var existingFeedbacks = retrieveFeedbacks()
        existingFeedbacks.insert(feedback, at: 0)
        
        if let encodedData = try? JSONEncoder().encode(existingFeedbacks) {
            UserDefaults.standard.set(encodedData, forKey: "UserFeedbacksArchive")
        }
    }
    
    func retrieveFeedbacks() -> [FeedbackModel] {
        guard let storedData = UserDefaults.standard.data(forKey: "UserFeedbacksArchive"),
              let decodedFeedbacks = try? JSONDecoder().decode([FeedbackModel].self, from: storedData) else {
            return []
        }
        return decodedFeedbacks
    }
    
    func showThankYouAnimation() {
        let thankYouView = UIView()
        thankYouView.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.95)
        thankYouView.layer.cornerRadius = 20
        thankYouView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thankYouView)
        
        let label = UILabel()
        label.text = "Thank you! 🎉"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        thankYouView.addSubview(label)
        
        NSLayoutConstraint.activate([
            thankYouView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thankYouView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            thankYouView.widthAnchor.constraint(equalToConstant: 200),
            thankYouView.heightAnchor.constraint(equalToConstant: 100),
            
            label.centerXAnchor.constraint(equalTo: thankYouView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: thankYouView.centerYAnchor)
        ])
        
        thankYouView.alpha = 0
        thankYouView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: []) {
            thankYouView.alpha = 1
            thankYouView.transform = .identity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.3, animations: {
                thankYouView.alpha = 0
                thankYouView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }) { _ in
                thankYouView.removeFromSuperview()
            }
        }
    }
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

