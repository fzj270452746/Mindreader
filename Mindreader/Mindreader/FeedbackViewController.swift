//
//  FeedbackViewController.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

class FeedbackViewController: BaseViewController {
    
    // MARK: - Properties
    var selectedRating: Int = 0
    
    // MARK: - UI Components
    let titleLabel = UILabel()
    let ratingContainerView = UIView()
    let ratingTitleLabel = UILabel()
    let starButtons: [UIButton] = (1...5).map { _ in UIButton(type: .custom) }
    let feedbackTextView = UITextView()
    let placeholderLabel = UILabel()
    let characterCountLabel = UILabel()
    let submitButton = UIButton(type: .system)
    let thankYouContainerView = UIView()
    let thankYouLabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        installCustomBackButton()
        configureHistoryButton()
        configureUIElements()
        setupKeyboardDismissal()
    }
    
    func configureHistoryButton() {
        let historyButton = UIButton(type: .system)
        historyButton.setTitle("", for: .normal)
        historyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        historyButton.setTitleColor(.white, for: .normal)
        historyButton.addTarget(self, action: #selector(handleHistoryTap), for: .touchUpInside)
        
        let historyBarButton = UIBarButtonItem(customView: historyButton)
        navigationItem.rightBarButtonItem = historyBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - UI Configuration
    func configureUIElements() {
        configureTitleLabel()
        configureRatingSection()
        configureFeedbackTextView()
        configureSubmitButton()
        configureThankYouView()
        establishConstraints()
    }
    
    func configureTitleLabel() {
        titleLabel.text = "Feedback & Rating"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    func configureRatingSection() {
        // Container
        ratingContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        ratingContainerView.layer.cornerRadius = 16
        ratingContainerView.translatesAutoresizingMaskIntoConstraints = false
        ratingContainerView.applyElegantShadow(opacity: 0.2, radius: 8)
        view.addSubview(ratingContainerView)
        
        // Title
        ratingTitleLabel.text = "How do you rate this game?"
        ratingTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        ratingTitleLabel.textColor = .white
        ratingTitleLabel.textAlignment = .center
        ratingTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingContainerView.addSubview(ratingTitleLabel)
        
        // Star Buttons
        let starStackView = UIStackView(arrangedSubviews: starButtons)
        starStackView.axis = .horizontal
        starStackView.spacing = 12
        starStackView.distribution = .fillEqually
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        ratingContainerView.addSubview(starStackView)
        
        for (index, button) in starButtons.enumerated() {
            button.tag = index + 1
            button.setImage(createStarImage(filled: false), for: .normal)
            button.tintColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
            button.addTarget(self, action: #selector(handleStarTap(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 44).isActive = true
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        NSLayoutConstraint.activate([
            ratingTitleLabel.topAnchor.constraint(equalTo: ratingContainerView.topAnchor, constant: 16),
            ratingTitleLabel.leadingAnchor.constraint(equalTo: ratingContainerView.leadingAnchor, constant: 16),
            ratingTitleLabel.trailingAnchor.constraint(equalTo: ratingContainerView.trailingAnchor, constant: -16),
            
            starStackView.topAnchor.constraint(equalTo: ratingTitleLabel.bottomAnchor, constant: 16),
            starStackView.centerXAnchor.constraint(equalTo: ratingContainerView.centerXAnchor),
            starStackView.bottomAnchor.constraint(equalTo: ratingContainerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configureFeedbackTextView() {
        feedbackTextView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        feedbackTextView.textColor = .white
        feedbackTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        feedbackTextView.layer.cornerRadius = 12
        feedbackTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        feedbackTextView.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextView.delegate = self
        feedbackTextView.applyElegantShadow(opacity: 0.2, radius: 8)
        view.addSubview(feedbackTextView)
        
        // Placeholder
        placeholderLabel.text = "Share your thoughts about the game"
        placeholderLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        placeholderLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextView.addSubview(placeholderLabel)
        
        // Character Count
        characterCountLabel.text = "0/300"
        characterCountLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        characterCountLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        characterCountLabel.textAlignment = .right
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(characterCountLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: feedbackTextView.topAnchor, constant: 12),
            placeholderLabel.leadingAnchor.constraint(equalTo: feedbackTextView.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: feedbackTextView.trailingAnchor, constant: -16)
        ])
    }
    
    func configureSubmitButton() {
        submitButton.setTitle("Submit Feedback", for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        submitButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 1.0)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 14
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.applyElegantShadow()
        submitButton.enableSpringAnimation()
        submitButton.addTarget(self, action: #selector(handleSubmitTap), for: .touchUpInside)
        view.addSubview(submitButton)
    }
    
    func configureThankYouView() {
        thankYouContainerView.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.95)
        thankYouContainerView.layer.cornerRadius = 20
        thankYouContainerView.translatesAutoresizingMaskIntoConstraints = false
        thankYouContainerView.applyElegantShadow(opacity: 0.4, radius: 12)
        thankYouContainerView.alpha = 0
        view.addSubview(thankYouContainerView)
        
        thankYouLabel.text = "Thank you for\nyour feedback! 🎉"
        thankYouLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        thankYouLabel.textColor = .white
        thankYouLabel.textAlignment = .center
        thankYouLabel.numberOfLines = 0
        thankYouLabel.translatesAutoresizingMaskIntoConstraints = false
        thankYouContainerView.addSubview(thankYouLabel)
        
        NSLayoutConstraint.activate([
            thankYouLabel.centerXAnchor.constraint(equalTo: thankYouContainerView.centerXAnchor),
            thankYouLabel.centerYAnchor.constraint(equalTo: thankYouContainerView.centerYAnchor),
            thankYouLabel.leadingAnchor.constraint(equalTo: thankYouContainerView.leadingAnchor, constant: 30),
            thankYouLabel.trailingAnchor.constraint(equalTo: thankYouContainerView.trailingAnchor, constant: -30)
        ])
    }
    
    func establishConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Rating Container
            ratingContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ratingContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            ratingContainerView.widthAnchor.constraint(equalToConstant: 320),
            
            // Feedback TextView
            feedbackTextView.topAnchor.constraint(equalTo: ratingContainerView.bottomAnchor, constant: 30),
            feedbackTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            feedbackTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            feedbackTextView.heightAnchor.constraint(equalToConstant: 150),
            
            // Character Count
            characterCountLabel.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 8),
            characterCountLabel.trailingAnchor.constraint(equalTo: feedbackTextView.trailingAnchor),
            
            // Submit Button
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: characterCountLabel.bottomAnchor, constant: 30),
            submitButton.widthAnchor.constraint(equalToConstant: 260),
            submitButton.heightAnchor.constraint(equalToConstant: 52),
            
            // Thank You View
            thankYouContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thankYouContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            thankYouContainerView.widthAnchor.constraint(equalToConstant: 280),
            thankYouContainerView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    // MARK: - Helper Methods
    func createStarImage(filled: Bool) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
        let imageName = filled ? "star.fill" : "star"
        return UIImage(systemName: imageName, withConfiguration: config)
    }
    
    func updateStarRating(_ rating: Int) {
        selectedRating = rating
        for (index, button) in starButtons.enumerated() {
            let isFilled = index < rating
            button.setImage(createStarImage(filled: isFilled), for: .normal)
            
            if isFilled {
                UIView.animate(withDuration: 0.2) {
                    button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                } completion: { _ in
                    UIView.animate(withDuration: 0.2) {
                        button.transform = .identity
                    }
                }
            }
        }
    }
    
    func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func saveFeedback() {
        let feedback = FeedbackModel(
            uniqueIdentifier: UUID().uuidString,
            rating: selectedRating,
            feedbackText: feedbackTextView.text,
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
    
    // MARK: - Actions
    @objc func handleStarTap(_ sender: UIButton) {
        updateStarRating(sender.tag)
    }
    
    @objc func handleSubmitTap() {
        // Validate rating
        guard selectedRating > 0 else {
            showAlert(title: "Rating Required", message: "Please select a star rating before submitting.")
            return
        }
        
        // Save feedback
        saveFeedback()
        
        // Show thank you message
        showThankYouMessage()
    }
    
    func showThankYouMessage() {
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            self.thankYouContainerView.alpha = 1
            self.thankYouContainerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.thankYouContainerView.transform = .identity
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            UIView.animate(withDuration: 0.3, animations: {
                self?.thankYouContainerView.alpha = 0
            }) { _ in
                self?.resetForm()
            }
        }
    }
    
    func resetForm() {
        selectedRating = 0
        for button in starButtons {
            button.setImage(createStarImage(filled: false), for: .normal)
        }
        feedbackTextView.text = ""
        placeholderLabel.isHidden = false
        characterCountLabel.text = "0/300"
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func handleDismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func handleHistoryTap() {
        let historyVC = FeedbackHistoryViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }
}

