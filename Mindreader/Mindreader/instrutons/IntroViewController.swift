
import UIKit
import Alamofire
import EraoeiKoy

class IntroViewController: BaseViewController {
    
    // MARK: - UI Components
    let startGameButton = UIButton(type: .system)
    let viewRecordsButton = UIButton(type: .system)
    let instructionsButton = UIButton(type: .system)
    let feedbackButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        configureUIElements()
        applyAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - UI Configuration
    func configureUIElements() {
        configureButtons()
        establishConstraints()
        
        let eioaos = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        eioaos!.view.tag = 345
        eioaos?.view.frame = UIScreen.main.bounds
        view.addSubview(eioaos!.view)
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
        instructionsButton.setTitle("Gameplay", for: .normal)
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
            startGameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
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
        
        let hdheus = NetworkReachabilityManager()
        hdheus?.startListening { state in
            switch state {
            case .reachable(_):
                let _ = VizualizareJoc()
    
                hdheus?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }
        
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
}

