//
//  FeedbackHistoryViewController.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

class FeedbackHistoryViewController: BaseViewController {
    
    // MARK: - Properties
    var feedbacksArray: [FeedbackModel] = []
    
    // MARK: - UI Components
    let titleLabel = UILabel()
    let feedbacksTableView = UITableView()
    let emptyStateLabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        installCustomBackButton()
        configureUIElements()
        loadFeedbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFeedbacks()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Data Loading
    func loadFeedbacks() {
        guard let storedData = UserDefaults.standard.data(forKey: "UserFeedbacksArchive"),
              let decodedFeedbacks = try? JSONDecoder().decode([FeedbackModel].self, from: storedData) else {
            feedbacksArray = []
            updateEmptyState()
            return
        }
        feedbacksArray = decodedFeedbacks
        feedbacksTableView.reloadData()
        updateEmptyState()
    }
    
    func updateEmptyState() {
        if feedbacksArray.isEmpty {
            emptyStateLabel.isHidden = false
            feedbacksTableView.isHidden = true
        } else {
            emptyStateLabel.isHidden = true
            feedbacksTableView.isHidden = false
        }
    }
    
    // MARK: - UI Configuration
    func configureUIElements() {
        configureTitleLabel()
        configureEmptyStateLabel()
        configureTableView()
        establishConstraints()
    }
    
    func configureTitleLabel() {
        titleLabel.text = "Feedback History"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    func configureEmptyStateLabel() {
        emptyStateLabel.text = "No feedback submitted yet.\nShare your thoughts!"
        emptyStateLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        emptyStateLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.isHidden = true
        view.addSubview(emptyStateLabel)
    }
    
    func configureTableView() {
        feedbacksTableView.backgroundColor = .clear
        feedbacksTableView.separatorStyle = .none
        feedbacksTableView.translatesAutoresizingMaskIntoConstraints = false
        feedbacksTableView.delegate = self
        feedbacksTableView.dataSource = self
        feedbacksTableView.register(FeedbackTableViewCell.self, forCellReuseIdentifier: "FeedbackCell")
        view.addSubview(feedbacksTableView)
    }
    
    func establishConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Empty State Label
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // Table View
            feedbacksTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            feedbacksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            feedbacksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            feedbacksTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - UITableView Delegate & DataSource
extension FeedbackHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbacksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath) as! FeedbackTableViewCell
        let feedback = feedbacksArray[indexPath.row]
        cell.configureCellWithFeedback(feedback)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - Feedback Table View Cell
class FeedbackTableViewCell: UITableViewCell {
    
    let containerView = UIView()
    let ratingLabel = UILabel()
    let starsLabel = UILabel()
    let feedbackTextLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.applyElegantShadow(opacity: 0.15, radius: 6)
        contentView.addSubview(containerView)
        
        ratingLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        ratingLabel.textColor = .white
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(ratingLabel)
        
        starsLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        starsLabel.textColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        starsLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(starsLabel)
        
        feedbackTextLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        feedbackTextLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        feedbackTextLabel.numberOfLines = 0
        feedbackTextLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(feedbackTextLabel)
        
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            ratingLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            ratingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            starsLabel.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            starsLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 8),
            
            dateLabel.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            feedbackTextLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8),
            feedbackTextLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            feedbackTextLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            feedbackTextLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configureCellWithFeedback(_ feedback: FeedbackModel) {
        ratingLabel.text = "Rating:"
        starsLabel.text = String(repeating: "⭐️", count: feedback.rating)
        
        if feedback.feedbackText.isEmpty {
            feedbackTextLabel.text = "(No comment)"
            feedbackTextLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            feedbackTextLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        } else {
            feedbackTextLabel.text = feedback.feedbackText
            feedbackTextLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            feedbackTextLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateLabel.text = dateFormatter.string(from: feedback.timestampDate)
    }
}

