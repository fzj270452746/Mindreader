//
//  MindreaderModel.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

// MARK: - Mahjong Tile Model
struct MahjongTileModel {
    let tileImage: UIImage?
    let numericalValue: Int // 1-9
    let suitCategory: TileSuitType
    
    var displayName: String {
        return "\(numericalValue) \(suitCategory.rawValue)"
    }
}

// MARK: - Tile Suit Types
enum TileSuitType: String, CaseIterable {
    case bamboo = "Bamboo"      // B系列
    case character = "Character" // N系列  
    case dot = "Dot"            // V系列
}

// MARK: - Game Mode
enum GameModeType {
    case classic    // 单一花色
    case advanced   // 三种花色
}

// MARK: - Game Record
struct GameRecordModel: Codable {
    let uniqueIdentifier: String
    let attemptCount: Int
    let gameModeType: String
    let achievedScore: Int
    let timestampDate: Date
    let targetTileDescription: String
}

// MARK: - Tile Data Provider
class MahjongTileDataProvider {
    static let sharedInstance = MahjongTileDataProvider()
    
    let bambooTiles: [MahjongTileModel]
    let characterTiles: [MahjongTileModel]
    let dotTiles: [MahjongTileModel]
    
    var allAvailableTiles: [MahjongTileModel] {
        return bambooTiles + characterTiles + dotTiles
    }
    
    private init() {
        // Bamboo tiles (B系列)
        bambooTiles = [
            MahjongTileModel(tileImage: UIImage(named: "Bimage 1"), numericalValue: 1, suitCategory: .bamboo),
            MahjongTileModel(tileImage: UIImage(named: "Bimage 2"), numericalValue: 2, suitCategory: .bamboo),
            MahjongTileModel(tileImage: UIImage(named: "Bimage 3"), numericalValue: 3, suitCategory: .bamboo),
            MahjongTileModel(tileImage: UIImage(named: "Bimage 4"), numericalValue: 4, suitCategory: .bamboo),
            MahjongTileModel(tileImage: UIImage(named: "Bimage 5"), numericalValue: 5, suitCategory: .bamboo),
            MahjongTileModel(tileImage: UIImage(named: "Bimage 6"), numericalValue: 6, suitCategory: .bamboo),
            MahjongTileModel(tileImage: UIImage(named: "Bimage 7"), numericalValue: 7, suitCategory: .bamboo),
            MahjongTileModel(tileImage: UIImage(named: "Bimage 8"), numericalValue: 8, suitCategory: .bamboo),
            MahjongTileModel(tileImage: UIImage(named: "Bimage 9"), numericalValue: 9, suitCategory: .bamboo)
        ]
        
        // Character tiles (N系列)
        characterTiles = [
            MahjongTileModel(tileImage: UIImage(named: "Nimage 1"), numericalValue: 1, suitCategory: .character),
            MahjongTileModel(tileImage: UIImage(named: "Nimage 2"), numericalValue: 2, suitCategory: .character),
            MahjongTileModel(tileImage: UIImage(named: "Nimage 3"), numericalValue: 3, suitCategory: .character),
            MahjongTileModel(tileImage: UIImage(named: "Nimage 4"), numericalValue: 4, suitCategory: .character),
            MahjongTileModel(tileImage: UIImage(named: "Nimage 5"), numericalValue: 5, suitCategory: .character),
            MahjongTileModel(tileImage: UIImage(named: "Nimage 6"), numericalValue: 6, suitCategory: .character),
            MahjongTileModel(tileImage: UIImage(named: "Nimage 7"), numericalValue: 7, suitCategory: .character),
            MahjongTileModel(tileImage: UIImage(named: "Nimage 8"), numericalValue: 8, suitCategory: .character),
            MahjongTileModel(tileImage: UIImage(named: "Nimage 9"), numericalValue: 9, suitCategory: .character)
        ]
        
        // Dot tiles (V系列)
        dotTiles = [
            MahjongTileModel(tileImage: UIImage(named: "Vimage 1"), numericalValue: 1, suitCategory: .dot),
            MahjongTileModel(tileImage: UIImage(named: "Vimage 2"), numericalValue: 2, suitCategory: .dot),
            MahjongTileModel(tileImage: UIImage(named: "Vimage 3"), numericalValue: 3, suitCategory: .dot),
            MahjongTileModel(tileImage: UIImage(named: "Vimage 4"), numericalValue: 4, suitCategory: .dot),
            MahjongTileModel(tileImage: UIImage(named: "Vimage 5"), numericalValue: 5, suitCategory: .dot),
            MahjongTileModel(tileImage: UIImage(named: "Vimage 6"), numericalValue: 6, suitCategory: .dot),
            MahjongTileModel(tileImage: UIImage(named: "Vimage 7"), numericalValue: 7, suitCategory: .dot),
            MahjongTileModel(tileImage: UIImage(named: "Vimage 8"), numericalValue: 8, suitCategory: .dot),
            MahjongTileModel(tileImage: UIImage(named: "Vimage 9"), numericalValue: 9, suitCategory: .dot)
        ]
    }
    
    func obtainTilesForSuit(_ suit: TileSuitType) -> [MahjongTileModel] {
        switch suit {
        case .bamboo:
            return bambooTiles
        case .character:
            return characterTiles
        case .dot:
            return dotTiles
        }
    }
}
