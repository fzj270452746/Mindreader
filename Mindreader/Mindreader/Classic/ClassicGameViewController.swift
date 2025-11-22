//
//  ClassicGameViewController.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

class ClassicGameViewController: BaseViewController {
    
    // MARK: - Game Properties
    var enigmaticTargetTile: MahjongTileModel!
    var currentAttemptCount = 0
    var selectedSuitCategory: TileSuitType = .bamboo
    var availableTilesArray: [MahjongTileModel] = []
    
    // MARK: - UI Components
    let titleLabel = UILabel()
    let attemptCounterLabel = UILabel()
    let feedbackMessageLabel = UILabel()
    let mysteryTileImageView = UIImageView()
    let tilesCollectionView: UICollectionView
    let resetGameButton = UIButton(type: .system)
    let suitSegmentedControl = UISegmentedControl(items: ["Bamboo", "Character", "Dot"])
    
    // MARK: - Initialization
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
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
        availableTilesArray = MahjongTileDataProvider.sharedInstance.obtainTilesForSuit(selectedSuitCategory)
        enigmaticTargetTile = availableTilesArray.randomElement()!
        currentAttemptCount = 0
    }
    
    // MARK: - UI Configuration
    func configureUIElements() {
        configureTitleLabel()
        configureAttemptCounter()
        configureFeedbackLabel()
        configureMysteryTileImage()
        configureSuitSelector()
        configureCollectionView()
        configureResetButton()
        establishConstraints()
    }
    
    func configureTitleLabel() {
        titleLabel.text = "Classic Iteration"
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
        feedbackMessageLabel.text = "Select a tile to commence"
        feedbackMessageLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
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
    
    func configureSuitSelector() {
        suitSegmentedControl.selectedSegmentIndex = 0
        suitSegmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        suitSegmentedControl.selectedSegmentTintColor = UIColor.white.withAlphaComponent(0.8)
        suitSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        suitSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        suitSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        suitSegmentedControl.addTarget(self, action: #selector(handleSuitChange), for: .valueChanged)
        view.addSubview(suitSegmentedControl)
    }
    
    func configureCollectionView() {
        tilesCollectionView.backgroundColor = .clear
        tilesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tilesCollectionView.delegate = self
        tilesCollectionView.dataSource = self
        tilesCollectionView.register(TileCollectionViewCell.self, forCellWithReuseIdentifier: "TileCell")
        view.addSubview(tilesCollectionView)
    }
    
    func configureResetButton() {
        resetGameButton.setTitle("Reinitialize Session", for: .normal)
        resetGameButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        resetGameButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.5, alpha: 1.0)
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
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            
            // Attempt Counter
            attemptCounterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            attemptCounterLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            
            // Mystery Tile
            mysteryTileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mysteryTileImageView.topAnchor.constraint(equalTo: attemptCounterLabel.bottomAnchor, constant: 20),
            mysteryTileImageView.widthAnchor.constraint(equalToConstant: 80),
            mysteryTileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Feedback Label
            feedbackMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedbackMessageLabel.topAnchor.constraint(equalTo: mysteryTileImageView.bottomAnchor, constant: 16),
            feedbackMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            feedbackMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Suit Selector
            suitSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            suitSegmentedControl.topAnchor.constraint(equalTo: feedbackMessageLabel.bottomAnchor, constant: 24),
            suitSegmentedControl.widthAnchor.constraint(equalToConstant: 320),
            suitSegmentedControl.heightAnchor.constraint(equalToConstant: 36),
            
            // Collection View
            tilesCollectionView.topAnchor.constraint(equalTo: suitSegmentedControl.bottomAnchor, constant: 20),
            tilesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tilesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tilesCollectionView.bottomAnchor.constraint(equalTo: resetGameButton.topAnchor, constant: -20),
            
            // Reset Button
            resetGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetGameButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            resetGameButton.widthAnchor.constraint(equalToConstant: 240),
            resetGameButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - Game Logic
    func evaluateGuess(_ guessedTile: MahjongTileModel) {
        currentAttemptCount += 1
        updateAttemptCounter()
        
        if guessedTile.numericalValue == enigmaticTargetTile.numericalValue {
            handleVictoriousOutcome(guessedTile)
        } else if guessedTile.numericalValue < enigmaticTargetTile.numericalValue {
            feedbackMessageLabel.text = "The enigmatic tile is HIGHER"
            feedbackMessageLabel.animateShakeEffect()
        } else {
            feedbackMessageLabel.text = "The enigmatic tile is LOWER"
            feedbackMessageLabel.animateShakeEffect()
        }
    }
    
    func handleVictoriousOutcome(_ discoveredTile: MahjongTileModel) {
        feedbackMessageLabel.text = "TRIUMPHANT! Score: \(GameDataPersistenceManager.sharedInstance.calculateScoreForAttempts(currentAttemptCount, mode: .classic))"
        feedbackMessageLabel.textColor = UIColor(red: 0.3, green: 0.9, blue: 0.5, alpha: 1.0)
        
        mysteryTileImageView.image = discoveredTile.tileImage
        mysteryTileImageView.alpha = 1.0
        mysteryTileImageView.animateRotation()
        
        let achievedScore = GameDataPersistenceManager.sharedInstance.calculateScoreForAttempts(currentAttemptCount, mode: .classic)
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
            gameModeType: "Classic Iteration",
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
    @objc func handleSuitChange() {
        let suitTypes: [TileSuitType] = [.bamboo, .character, .dot]
        selectedSuitCategory = suitTypes[suitSegmentedControl.selectedSegmentIndex]
        handleResetGame()
    }
    
    @objc func handleResetGame() {
        initializeGameSession()
        currentAttemptCount = 0
        updateAttemptCounter()
        feedbackMessageLabel.text = "Select a tile to commence"
        feedbackMessageLabel.textColor = UIColor.white.withAlphaComponent(0.95)
        mysteryTileImageView.image = UIImage(systemName: "questionmark.square.fill")
        mysteryTileImageView.alpha = 0.6
        tilesCollectionView.reloadData()
    }
}

