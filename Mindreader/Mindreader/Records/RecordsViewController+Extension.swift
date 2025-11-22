//
//  RecordsViewController+Extension.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

// MARK: - UITableView Delegate & DataSource
extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameRecordsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordTableViewCell
        let record = gameRecordsArray[indexPath.row]
        cell.configureCellWithRecord(record)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            handleDeleteRecord(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Expunge") { [weak self] _, _, completion in
            self?.handleDeleteRecord(at: indexPath)
            completion(true)
        }
        deleteAction.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - Record Table View Cell
class RecordTableViewCell: UITableViewCell {
    
    let containerView = UIView()
    let modeLabel = UILabel()
    let attemptsLabel = UILabel()
    let scoreLabel = UILabel()
    let dateLabel = UILabel()
    let targetTileLabel = UILabel()
    let separatorLine = UIView()
    
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
        
        modeLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        modeLabel.textColor = .white
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(modeLabel)
        
        scoreLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        scoreLabel.textColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        scoreLabel.textAlignment = .right
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(scoreLabel)
        
        attemptsLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        attemptsLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        attemptsLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(attemptsLabel)
        
        targetTileLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        targetTileLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        targetTileLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(targetTileLabel)
        
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            modeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            modeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            scoreLabel.centerYAnchor.constraint(equalTo: modeLabel.centerYAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            attemptsLabel.topAnchor.constraint(equalTo: modeLabel.bottomAnchor, constant: 8),
            attemptsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            targetTileLabel.topAnchor.constraint(equalTo: attemptsLabel.bottomAnchor, constant: 4),
            targetTileLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            dateLabel.topAnchor.constraint(equalTo: targetTileLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configureCellWithRecord(_ record: GameRecordModel) {
        modeLabel.text = record.gameModeType
        attemptsLabel.text = "Attempts: \(record.attemptCount)"
        scoreLabel.text = "\(record.achievedScore)"
        targetTileLabel.text = "Target: \(record.targetTileDescription)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateLabel.text = dateFormatter.string(from: record.timestampDate)
    }
}

