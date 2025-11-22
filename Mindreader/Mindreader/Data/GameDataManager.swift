//
//  GameDataManager.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import Foundation

class GameDataPersistenceManager {
    static let sharedInstance = GameDataPersistenceManager()
    
    let recordsStorageKey = "MahjongMindreaderRecordsArchive"
    
    private init() {}
    
    // MARK: - Save Record
    func archiveGameRecord(_ record: GameRecordModel) {
        var existingRecords = retrieveAllGameRecords()
        existingRecords.insert(record, at: 0)
        
        if let encodedData = try? JSONEncoder().encode(existingRecords) {
            UserDefaults.standard.set(encodedData, forKey: recordsStorageKey)
        }
    }
    
    // MARK: - Retrieve Records
    func retrieveAllGameRecords() -> [GameRecordModel] {
        guard let storedData = UserDefaults.standard.data(forKey: recordsStorageKey),
              let decodedRecords = try? JSONDecoder().decode([GameRecordModel].self, from: storedData) else {
            return []
        }
        return decodedRecords
    }
    
    // MARK: - Delete Record
    func obliterateRecord(withIdentifier identifier: String) {
        var existingRecords = retrieveAllGameRecords()
        existingRecords.removeAll { $0.uniqueIdentifier == identifier }
        
        if let encodedData = try? JSONEncoder().encode(existingRecords) {
            UserDefaults.standard.set(encodedData, forKey: recordsStorageKey)
        }
    }
    
    // MARK: - Delete All Records
    func obliterateAllRecords() {
        UserDefaults.standard.removeObject(forKey: recordsStorageKey)
    }
    
    // MARK: - Calculate Score
    func calculateScoreForAttempts(_ attempts: Int, mode: GameModeType) -> Int {
        let baseScore = mode == .classic ? 100 : 200
        let penalty = attempts - 1
        let finalScore = max(baseScore - (penalty * 10), 10)
        return finalScore
    }
}

