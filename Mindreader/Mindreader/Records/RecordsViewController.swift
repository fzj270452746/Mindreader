//
//  RecordsViewController.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

class RecordsViewController: BaseViewController {
    
    // MARK: - Properties
    var gameRecordsArray: [GameRecordModel] = []
    
    // MARK: - UI Components
    let titleLabel = UILabel()
    let recordsTableView = UITableView()
    let emptyStateLabel = UILabel()
    let clearAllRecordsButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        installCustomBackButton()
        configureUIElements()
        loadGameRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGameRecords()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Data Loading
    func loadGameRecords() {
        gameRecordsArray = GameDataPersistenceManager.sharedInstance.retrieveAllGameRecords()
        recordsTableView.reloadData()
        updateEmptyState()
    }
    
    func updateEmptyState() {
        if gameRecordsArray.isEmpty {
            emptyStateLabel.isHidden = false
            recordsTableView.isHidden = true
            clearAllRecordsButton.isHidden = true
        } else {
            emptyStateLabel.isHidden = true
            recordsTableView.isHidden = false
            clearAllRecordsButton.isHidden = false
        }
    }
    
    // MARK: - UI Configuration
    func configureUIElements() {
        configureTitleLabel()
        configureEmptyStateLabel()
        configureTableView()
        configureClearButton()
        establishConstraints()
    }
    
    func configureTitleLabel() {
        titleLabel.text = "Chronicle Archive"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    func configureEmptyStateLabel() {
        emptyStateLabel.text = "No chronicles recorded yet.\nCommence gameplay to establish records!"
        emptyStateLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        emptyStateLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.isHidden = true
        view.addSubview(emptyStateLabel)
    }
    
    func configureTableView() {
        recordsTableView.backgroundColor = .clear
        recordsTableView.separatorStyle = .none
        recordsTableView.translatesAutoresizingMaskIntoConstraints = false
        recordsTableView.delegate = self
        recordsTableView.dataSource = self
        recordsTableView.register(RecordTableViewCell.self, forCellReuseIdentifier: "RecordCell")
        view.addSubview(recordsTableView)
    }
    
    func configureClearButton() {
        clearAllRecordsButton.setTitle("Delete", for: .normal)
        clearAllRecordsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        clearAllRecordsButton.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        clearAllRecordsButton.setTitleColor(.white, for: .normal)
        clearAllRecordsButton.layer.cornerRadius = 12
        clearAllRecordsButton.translatesAutoresizingMaskIntoConstraints = false
        clearAllRecordsButton.applyElegantShadow()
        clearAllRecordsButton.enableSpringAnimation()
        clearAllRecordsButton.addTarget(self, action: #selector(handleClearAllRecords), for: .touchUpInside)
        view.addSubview(clearAllRecordsButton)
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
            recordsTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            recordsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            recordsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            recordsTableView.bottomAnchor.constraint(equalTo: clearAllRecordsButton.topAnchor, constant: -16),
            
            // Clear Button
            clearAllRecordsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearAllRecordsButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            clearAllRecordsButton.widthAnchor.constraint(equalToConstant: 260),
            clearAllRecordsButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - Actions
    @objc func handleClearAllRecords() {
        let alertController = UIAlertController(
            title: "Delete all records?",
            message: "This action is irreversible. All records will be permanently expunged.",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            GameDataPersistenceManager.sharedInstance.obliterateAllRecords()
            self?.loadGameRecords()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func handleDeleteRecord(at indexPath: IndexPath) {
        let record = gameRecordsArray[indexPath.row]
        GameDataPersistenceManager.sharedInstance.obliterateRecord(withIdentifier: record.uniqueIdentifier)
        gameRecordsArray.remove(at: indexPath.row)
        recordsTableView.deleteRows(at: [indexPath], with: .fade)
        updateEmptyState()
    }
}

