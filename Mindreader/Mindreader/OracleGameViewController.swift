//
//  OracleGameViewController.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

class OracleGameViewController: BaseViewController {
    
    // MARK: - Game Properties
    var questionCount = 0
    var possibleTiles: [MahjongTileModel] = []
    var currentQuestion: OracleQuestion?
    var currentGuessedTile: MahjongTileModel?
    
    // MARK: - UI Components
    let titleLabel = UILabel()
    let instructionLabel = UILabel()
    let questionCountLabel = UILabel()
    let questionContainerView = UIView()
    let questionLabel = UILabel()
    let yesButton = UIButton(type: .system)
    let noButton = UIButton(type: .system)
    let correctButton = UIButton(type: .system)
    let wrongButton = UIButton(type: .system)
    let resetButton = UIButton(type: .system)
    let thinkingIndicator = UIActivityIndicatorView(style: .large)
    let revealedTileImageView = UIImageView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        installCustomBackButton()
        configureUIElements()
        initializeGame()  // Call after UI is configured
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Game Initialization
    func initializeGame() {
        questionCount = 0
        possibleTiles = MahjongTileDataProvider.sharedInstance.allAvailableTiles
        generateNextQuestion()
    }
    
    // MARK: - UI Configuration
    func configureUIElements() {
        configureTitleLabel()
        configureInstructionLabel()
        configureQuestionCounter()
        configureQuestionContainer()
        configureButtons()
        configureThinkingIndicator()
        establishConstraints()
    }
    
    func configureTitleLabel() {
        titleLabel.text = "Oracle Mode"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    func configureInstructionLabel() {
        instructionLabel.text = "Think of a tile...\nI will guess it!"
        instructionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        instructionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionLabel)
    }
    
    func configureQuestionCounter() {
        questionCountLabel.text = "Question: 0"
        questionCountLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        questionCountLabel.textColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        questionCountLabel.textAlignment = .center
        questionCountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionCountLabel)
    }
    
    func configureQuestionContainer() {
        questionContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        questionContainerView.layer.cornerRadius = 20
        questionContainerView.translatesAutoresizingMaskIntoConstraints = false
        questionContainerView.applyElegantShadow(opacity: 0.3, radius: 10)
        view.addSubview(questionContainerView)
        
        questionLabel.text = ""
        questionLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        questionLabel.textColor = .white
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionContainerView.addSubview(questionLabel)
        
        revealedTileImageView.contentMode = .scaleAspectFit
        revealedTileImageView.translatesAutoresizingMaskIntoConstraints = false
        revealedTileImageView.alpha = 0
        questionContainerView.addSubview(revealedTileImageView)
        
        NSLayoutConstraint.activate([
            revealedTileImageView.centerXAnchor.constraint(equalTo: questionContainerView.centerXAnchor),
            revealedTileImageView.topAnchor.constraint(equalTo: questionContainerView.topAnchor, constant: 30),
            revealedTileImageView.widthAnchor.constraint(equalToConstant: 80),
            revealedTileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            questionLabel.centerXAnchor.constraint(equalTo: questionContainerView.centerXAnchor),
            questionLabel.centerYAnchor.constraint(equalTo: questionContainerView.centerYAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: questionContainerView.leadingAnchor, constant: 30),
            questionLabel.trailingAnchor.constraint(equalTo: questionContainerView.trailingAnchor, constant: -30)
        ])
    }
    
    func configureButtons() {
        // YES Button
        yesButton.setTitle("YES", for: .normal)
        yesButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        yesButton.backgroundColor = UIColor(red: 0.3, green: 0.8, blue: 0.4, alpha: 1.0)
        yesButton.setTitleColor(.white, for: .normal)
        yesButton.layer.cornerRadius = 16
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.applyElegantShadow()
        yesButton.enableSpringAnimation()
        yesButton.addTarget(self, action: #selector(handleYesTap), for: .touchUpInside)
        view.addSubview(yesButton)
        
        // NO Button
        noButton.setTitle("NO", for: .normal)
        noButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        noButton.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        noButton.setTitleColor(.white, for: .normal)
        noButton.layer.cornerRadius = 16
        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.applyElegantShadow()
        noButton.enableSpringAnimation()
        noButton.addTarget(self, action: #selector(handleNoTap), for: .touchUpInside)
        view.addSubview(noButton)
        
        // Correct Button
        correctButton.setTitle("✓ Correct", for: .normal)
        correctButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        correctButton.backgroundColor = UIColor(red: 0.3, green: 0.8, blue: 0.4, alpha: 1.0)
        correctButton.setTitleColor(.white, for: .normal)
        correctButton.layer.cornerRadius = 16
        correctButton.translatesAutoresizingMaskIntoConstraints = false
        correctButton.applyElegantShadow()
        correctButton.enableSpringAnimation()
        correctButton.addTarget(self, action: #selector(handleCorrectTap), for: .touchUpInside)
        correctButton.alpha = 0
        correctButton.isHidden = true
        view.addSubview(correctButton)
        
        // Wrong Button
        wrongButton.setTitle("✗ Wrong", for: .normal)
        wrongButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        wrongButton.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        wrongButton.setTitleColor(.white, for: .normal)
        wrongButton.layer.cornerRadius = 16
        wrongButton.translatesAutoresizingMaskIntoConstraints = false
        wrongButton.applyElegantShadow()
        wrongButton.enableSpringAnimation()
        wrongButton.addTarget(self, action: #selector(handleWrongTap), for: .touchUpInside)
        wrongButton.alpha = 0
        wrongButton.isHidden = true
        view.addSubview(wrongButton)
        
        // Reset Button
        resetButton.setTitle("Start New Game", for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        resetButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.8, alpha: 1.0)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 12
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.applyElegantShadow()
        resetButton.enableSpringAnimation()
        resetButton.addTarget(self, action: #selector(handleResetTap), for: .touchUpInside)
        view.addSubview(resetButton)
    }
    
    func configureThinkingIndicator() {
        thinkingIndicator.color = .white
        thinkingIndicator.translatesAutoresizingMaskIntoConstraints = false
        thinkingIndicator.hidesWhenStopped = true
        view.addSubview(thinkingIndicator)
    }
    
    func establishConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            
            // Instruction
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            
            // Question Count
            questionCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionCountLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            
            // Question Container
            questionContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            questionContainerView.widthAnchor.constraint(equalToConstant: 320),
            questionContainerView.heightAnchor.constraint(equalToConstant: 200),
            
            // Thinking Indicator
            thinkingIndicator.centerXAnchor.constraint(equalTo: questionContainerView.centerXAnchor),
            thinkingIndicator.centerYAnchor.constraint(equalTo: questionContainerView.centerYAnchor),
            
            // YES Button
            yesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            yesButton.topAnchor.constraint(equalTo: questionContainerView.bottomAnchor, constant: 40),
            yesButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            yesButton.heightAnchor.constraint(equalToConstant: 60),
            
            // NO Button
            noButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            noButton.topAnchor.constraint(equalTo: questionContainerView.bottomAnchor, constant: 40),
            noButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            noButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Correct Button
            correctButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            correctButton.topAnchor.constraint(equalTo: questionContainerView.bottomAnchor, constant: 40),
            correctButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            correctButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Wrong Button
            wrongButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            wrongButton.topAnchor.constraint(equalTo: questionContainerView.bottomAnchor, constant: 40),
            wrongButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            wrongButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Reset Button
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            resetButton.widthAnchor.constraint(equalToConstant: 220),
            resetButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - Game Logic
    func generateNextQuestion() {
        questionCount += 1
        updateQuestionCounter()
        
        print("📊 Question \(questionCount), Remaining tiles: \(possibleTiles.count)")
        
        // Check if we can guess
        if possibleTiles.count == 1 {
            print("✅ Found the tile!")
            revealGuess(possibleTiles[0])
            return
        }
        
        if possibleTiles.count == 0 {
            print("❌ No tiles left - error in logic")
            return
        }
        
        // Generate best question using AI strategy
        currentQuestion = AIQuestionGenerator.generateOptimalQuestion(from: possibleTiles)
        
        if let question = currentQuestion {
            print("❓ Question: \(question.questionText)")
            showQuestion(question)
        } else {
            // Fallback: make random guess
            print("🎲 Fallback to random guess")
            if let randomTile = possibleTiles.randomElement() {
                revealGuess(randomTile)
            }
        }
    }
    
    func showQuestion(_ question: OracleQuestion) {
        print("💬 Showing question: \(question.questionText)")
        
        // Hide tile image when showing question
        UIView.animate(withDuration: 0.2) {
            self.revealedTileImageView.alpha = 0
        }
        
        questionLabel.alpha = 0
        questionLabel.text = question.questionText
        questionLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        UIView.animate(withDuration: 0.4) {
            self.questionLabel.alpha = 1
        }
        
        // Make sure YES/NO buttons are visible and Confirm is hidden
        yesButton.alpha = 1
        noButton.alpha = 1
        yesButton.isHidden = false
        noButton.isHidden = false
        correctButton.alpha = 0
        wrongButton.alpha = 0
        correctButton.isHidden = true
        wrongButton.isHidden = true
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func processAnswer(isYes: Bool) {
        guard let question = currentQuestion else {
            print("⚠️ No current question")
            return
        }
        
        // Disable buttons during processing
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        // Show thinking animation
        showThinkingAnimation()
        
        // Filter tiles based on answer
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            self.hideThinkingAnimation()
            
            if isYes {
                self.possibleTiles = self.possibleTiles.filter { question.predicate($0) }
            } else {
                self.possibleTiles = self.possibleTiles.filter { !question.predicate($0) }
            }
            
            print("🔍 Remaining tiles: \(self.possibleTiles.count)")
            
            self.generateNextQuestion()
        }
    }
    
    func revealGuess(_ tile: MahjongTileModel) {
        print("🎯 Revealing guess: \(tile.displayName)")
        
        instructionLabel.text = "I think it's..."
        
        // Show tile image
        revealedTileImageView.image = tile.tileImage
        
        // Update question label
        questionLabel.text = "\(tile.displayName)!"
        questionLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        // Show tile image with animation
        UIView.animate(withDuration: 0.6) {
            self.revealedTileImageView.alpha = 1
            self.questionLabel.alpha = 1
        }
        
        // Hide YES/NO buttons and show Correct/Wrong buttons
        print("🔘 Hiding YES/NO, showing Correct/Wrong")
        UIView.animate(withDuration: 0.3) {
            self.yesButton.alpha = 0
            self.noButton.alpha = 0
            self.yesButton.isHidden = true
            self.noButton.isHidden = true
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.correctButton.alpha = 1
                self.wrongButton.alpha = 1
                self.correctButton.isHidden = false
                self.wrongButton.isHidden = false
            }
            print("✓ Correct/Wrong buttons should be visible now")
        }
        
        // Store the guessed tile for later
        currentGuessedTile = tile
    }
    
    func showThinkingAnimation() {
        questionLabel.alpha = 0.3
        thinkingIndicator.startAnimating()
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func hideThinkingAnimation() {
        questionLabel.alpha = 1.0
        thinkingIndicator.stopAnimating()
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func calculateScore() -> Int {
        // More questions = higher player score
        let baseScore = 10
        let questionBonus = questionCount * 10
        return min(baseScore + questionBonus, 100)
    }
    
    func saveGameResult(score: Int, success: Bool, tile: MahjongTileModel) {
        let record = GameRecordModel(
            uniqueIdentifier: UUID().uuidString,
            attemptCount: questionCount,
            gameModeType: "Oracle Mode",
            achievedScore: score,
            timestampDate: Date(),
            targetTileDescription: tile.displayName
        )
        GameDataPersistenceManager.sharedInstance.archiveGameRecord(record)
    }
    
    func updateQuestionCounter() {
        questionCountLabel.text = "Question: \(questionCount)"
    }
    
    // MARK: - Actions
    @objc func handleYesTap() {
        processAnswer(isYes: true)
    }
    
    @objc func handleNoTap() {
        processAnswer(isYes: false)
    }
    
    @objc func handleCorrectTap() {
        guard let tile = currentGuessedTile else { return }
        
        let score = calculateScore()
        saveGameResult(score: score, success: true, tile: tile)
        
        // Show brief success message
        feedbackMessageLabel.text = "AI Win! Score: \(score) points!"
        feedbackMessageLabel.textColor = UIColor(red: 0.3, green: 0.9, blue: 0.5, alpha: 1.0)
        feedbackMessageLabel.alpha = 0
        view.addSubview(feedbackMessageLabel)
        
        feedbackMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedbackMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedbackMessageLabel.bottomAnchor.constraint(equalTo: correctButton.topAnchor, constant: -20)
        ])
        
        UIView.animate(withDuration: 0.3) {
            self.feedbackMessageLabel.alpha = 1
        }
        
        // Auto restart after 1.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.handleResetTap()
        }
    }
    
    @objc func handleWrongTap() {
        guard let tile = currentGuessedTile else { return }
        
        // If AI is wrong, player gets perfect score
        let score = 100
        saveGameResult(score: score, success: false, tile: tile)
        
        // Show success message
        feedbackMessageLabel.text = "You Win! Score: \(score) points!"
        feedbackMessageLabel.textColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        feedbackMessageLabel.alpha = 0
        view.addSubview(feedbackMessageLabel)
        
        feedbackMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedbackMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedbackMessageLabel.bottomAnchor.constraint(equalTo: correctButton.topAnchor, constant: -20)
        ])
        
        UIView.animate(withDuration: 0.3) {
            self.feedbackMessageLabel.alpha = 1
        }
        
        // Auto restart after 1.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.handleResetTap()
        }
    }
    
    let feedbackMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    @objc func handleResetTap() {
        print("🔄 Resetting game...")
        
        // Reset UI first
        instructionLabel.text = "Think of a tile...\nI will guess it!"
        revealedTileImageView.alpha = 0
        feedbackMessageLabel.alpha = 0
        currentGuessedTile = nil
        
        // Show YES/NO buttons, hide Correct/Wrong buttons
        UIView.animate(withDuration: 0.3) {
            self.yesButton.alpha = 1
            self.noButton.alpha = 1
            self.yesButton.isHidden = false
            self.noButton.isHidden = false
            self.correctButton.alpha = 0
            self.wrongButton.alpha = 0
            self.correctButton.isHidden = true
            self.wrongButton.isHidden = true
        }
        
        // Initialize game (this will generate first question)
        initializeGame()
    }
    
}

