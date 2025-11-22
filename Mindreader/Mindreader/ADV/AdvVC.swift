//
//  AdvancedGameViewController.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

class AdvVC: BaseViewController {
    
    // MARK: - Game Properties
    var enigmaticTargetTile: MahjongTileModel!
    var currentAttemptCount = 0
    var allAvailableTiles: [MahjongTileModel] = []
    var discernedSuitCategory: TileSuitType?
    var discernedNumericalValue: Int?
    
    // MARK: - UI Components
    let titleLabel = UILabel()
    let attemptCounterLabel = UILabel()
    let feedbackMessageLabel = UILabel()
    let mysteryTileImageView = UIImageView()
    let tilesCollectionView: UICollectionView
    let resetGameButton = UIButton(type: .system)
    let hintContainerView = UIView()
    let suitStatusLabel = UILabel()
    let numberStatusLabel = UILabel()
    
    // MARK: - Initialization
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 14
        tilesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeGameSession()
        configureUIElements()
        installCustomBackButton()
    }
    
    // MARK: - Game Initialization
    func initializeGameSession() {
        allAvailableTiles = MahjongTileDataProvider.sharedInstance.allAvailableTiles
        enigmaticTargetTile = allAvailableTiles.randomElement()!
        currentAttemptCount = 0
        discernedSuitCategory = nil
        discernedNumericalValue = nil
    }
    
    // MARK: - UI Configuration
    func configureUIElements() {
        configureTitleLabel()
        configureAttemptCounter()
        configureFeedbackLabel()
        configureMysteryTileImage()
        configureHintContainer()
        configureCollectionView()
        configureResetButton()
        establishConstraints()
    }
    
    func configureTitleLabel() {
        titleLabel.text = "Enigmatic Iteration"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    func configureAttemptCounter() {
        attemptCounterLabel.text = "Attempts: 0"
        attemptCounterLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        attemptCounterLabel.textColor = .white
        attemptCounterLabel.textAlignment = .center
        attemptCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(attemptCounterLabel)
    }
    
    func configureFeedbackLabel() {
        feedbackMessageLabel.text = "Deduce from 27 tiles"
        feedbackMessageLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        feedbackMessageLabel.textColor = UIColor.white.withAlphaComponent(0.95)
        feedbackMessageLabel.textAlignment = .center
        feedbackMessageLabel.numberOfLines = 0
        feedbackMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(feedbackMessageLabel)
    }
    
    func configureMysteryTileImage() {
        mysteryTileImageView.image = UIImage(systemName: "questionmark.square.fill")
        mysteryTileImageView.tintColor = .white
        mysteryTileImageView.contentMode = .scaleAspectFit
        mysteryTileImageView.translatesAutoresizingMaskIntoConstraints = false
        mysteryTileImageView.alpha = 0.6
        view.addSubview(mysteryTileImageView)
    }
    
    func configureHintContainer() {
        hintContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        hintContainerView.layer.cornerRadius = 12
        hintContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hintContainerView)
        
        suitStatusLabel.text = "Suit: Unknown"
        suitStatusLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        suitStatusLabel.textColor = .white
        suitStatusLabel.textAlignment = .center
        suitStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        hintContainerView.addSubview(suitStatusLabel)
        
        numberStatusLabel.text = "Number: Unknown"
        numberStatusLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        numberStatusLabel.textColor = .white
        numberStatusLabel.textAlignment = .center
        numberStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        hintContainerView.addSubview(numberStatusLabel)
        
        NSLayoutConstraint.activate([
            suitStatusLabel.topAnchor.constraint(equalTo: hintContainerView.topAnchor, constant: 8),
            suitStatusLabel.leadingAnchor.constraint(equalTo: hintContainerView.leadingAnchor, constant: 12),
            suitStatusLabel.trailingAnchor.constraint(equalTo: hintContainerView.trailingAnchor, constant: -12),
            
            numberStatusLabel.topAnchor.constraint(equalTo: suitStatusLabel.bottomAnchor, constant: 6),
            numberStatusLabel.leadingAnchor.constraint(equalTo: hintContainerView.leadingAnchor, constant: 12),
            numberStatusLabel.trailingAnchor.constraint(equalTo: hintContainerView.trailingAnchor, constant: -12),
            numberStatusLabel.bottomAnchor.constraint(equalTo: hintContainerView.bottomAnchor, constant: -8)
        ])
    }
    
    func configureCollectionView() {
        tilesCollectionView.backgroundColor = .clear
        tilesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tilesCollectionView.delegate = self
        tilesCollectionView.dataSource = self
        tilesCollectionView.register(AdvancedTileCell.self, forCellWithReuseIdentifier: "AdvancedTileCell")
        view.addSubview(tilesCollectionView)
    }
    
    func configureResetButton() {
        resetGameButton.setTitle("Reinitialize Session", for: .normal)
        resetGameButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        resetGameButton.backgroundColor = UIColor(red: 0.8, green: 0.3, blue: 0.4, alpha: 1.0)
        resetGameButton.setTitleColor(.white, for: .normal)
        resetGameButton.layer.cornerRadius = 12
        resetGameButton.translatesAutoresizingMaskIntoConstraints = false
        resetGameButton.applyElegantShadow()
        resetGameButton.enableSpringAnimation()
        resetGameButton.addTarget(self, action: #selector(handleResetGame), for: .touchUpInside)
        view.addSubview(resetGameButton)
    }
    
    func establishConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            
            // Attempt Counter
            attemptCounterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            attemptCounterLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            // Mystery Tile
            mysteryTileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mysteryTileImageView.topAnchor.constraint(equalTo: attemptCounterLabel.bottomAnchor, constant: 16),
            mysteryTileImageView.widthAnchor.constraint(equalToConstant: 70),
            mysteryTileImageView.heightAnchor.constraint(equalToConstant: 70),
            
            // Feedback Label
            feedbackMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedbackMessageLabel.topAnchor.constraint(equalTo: mysteryTileImageView.bottomAnchor, constant: 12),
            feedbackMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            feedbackMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Hint Container
            hintContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hintContainerView.topAnchor.constraint(equalTo: feedbackMessageLabel.bottomAnchor, constant: 16),
            hintContainerView.widthAnchor.constraint(equalToConstant: 260),
            hintContainerView.heightAnchor.constraint(equalToConstant: 70),
            
            // Collection View
            tilesCollectionView.topAnchor.constraint(equalTo: hintContainerView.bottomAnchor, constant: 16),
            tilesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tilesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tilesCollectionView.bottomAnchor.constraint(equalTo: resetGameButton.topAnchor, constant: -16),
            
            // Reset Button
            resetGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetGameButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
            resetGameButton.widthAnchor.constraint(equalToConstant: 240),
            resetGameButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - Game Logic
    func evaluateGuess(_ guessedTile: MahjongTileModel) {
        currentAttemptCount += 1
        updateAttemptCounter()
        
        let correctSuit = guessedTile.suitCategory == enigmaticTargetTile.suitCategory
        let correctNumber = guessedTile.numericalValue == enigmaticTargetTile.numericalValue
        
        if correctSuit && correctNumber {
            handleVictoriousOutcome(guessedTile)
        } else if correctNumber && !correctSuit {
            feedbackMessageLabel.text = "Numerical concordance achieved!\nSuit remains enigmatic"
            feedbackMessageLabel.animateShakeEffect()
            discernedNumericalValue = guessedTile.numericalValue
            updateHintDisplay()
        } else if correctSuit && !correctNumber {
            let comparison = guessedTile.numericalValue < enigmaticTargetTile.numericalValue ? "HIGHER" : "LOWER"
            feedbackMessageLabel.text = "Suit concordance achieved!\nTarget is \(comparison)"
            feedbackMessageLabel.animateShakeEffect()
            discernedSuitCategory = guessedTile.suitCategory
            updateHintDisplay()
        } else {
            feedbackMessageLabel.text = "Both suit & number are incongruent\nContinue deduction"
            feedbackMessageLabel.animateShakeEffect()
        }
    }
    
    func updateHintDisplay() {
        if let suit = discernedSuitCategory {
            suitStatusLabel.text = "Suit: \(suit.rawValue) ✓"
            suitStatusLabel.textColor = UIColor(red: 0.3, green: 0.9, blue: 0.5, alpha: 1.0)
        }
        
        if let number = discernedNumericalValue {
            numberStatusLabel.text = "Number: \(number) ✓"
            numberStatusLabel.textColor = UIColor(red: 0.3, green: 0.9, blue: 0.5, alpha: 1.0)
        }
    }
    
    func handleVictoriousOutcome(_ discoveredTile: MahjongTileModel) {
        feedbackMessageLabel.text = "TRIUMPHANT! Score: \(GameDataPersistenceManager.sharedInstance.calculateScoreForAttempts(currentAttemptCount, mode: .advanced))"
        feedbackMessageLabel.textColor = UIColor(red: 0.3, green: 0.9, blue: 0.5, alpha: 1.0)
        
        mysteryTileImageView.image = discoveredTile.tileImage
        mysteryTileImageView.alpha = 1.0
        mysteryTileImageView.animateRotation()
        
        let achievedScore = GameDataPersistenceManager.sharedInstance.calculateScoreForAttempts(currentAttemptCount, mode: .advanced)
        archiveGameResult(score: achievedScore, targetTile: discoveredTile)
        
        // Auto restart after 1.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.handleResetGame()
        }
    }
    
    func archiveGameResult(score: Int, targetTile: MahjongTileModel) {
        let gameRecord = GameRecordModel(
            uniqueIdentifier: UUID().uuidString,
            attemptCount: currentAttemptCount,
            gameModeType: "Enigmatic Iteration",
            achievedScore: score,
            timestampDate: Date(),
            targetTileDescription: targetTile.displayName
        )
        GameDataPersistenceManager.sharedInstance.archiveGameRecord(gameRecord)
    }
    
    
    func updateAttemptCounter() {
        attemptCounterLabel.text = "Attempts: \(currentAttemptCount)"
    }
    
    // MARK: - Actions
    @objc func handleResetGame() {
        initializeGameSession()
        currentAttemptCount = 0
        updateAttemptCounter()
        feedbackMessageLabel.text = "Deduce from 27 tiles"
        feedbackMessageLabel.textColor = UIColor.white.withAlphaComponent(0.95)
        mysteryTileImageView.image = UIImage(systemName: "questionmark.square.fill")
        mysteryTileImageView.alpha = 0.6
        suitStatusLabel.text = "Suit: Unknown"
        suitStatusLabel.textColor = .white
        numberStatusLabel.text = "Number: Unknown"
        numberStatusLabel.textColor = .white
        tilesCollectionView.reloadData()
    }
}

