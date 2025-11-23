//
//  OracleGameViewController+Extension.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

// MARK: - Oracle Question Model
struct OracleQuestion {
    let questionText: String
    let predicate: (MahjongTileModel) -> Bool
}

// MARK: - AI Question Generator
class AIQuestionGenerator {
    
    static func generateOptimalQuestion(from tiles: [MahjongTileModel]) -> OracleQuestion? {
        guard tiles.count > 1 else { return nil }
        
        print("🤖 AI analyzing \(tiles.count) tiles...")
        
        // Check how many different suits we have
        let bambooCount = tiles.filter { $0.suitCategory == .bamboo }.count
        let characterCount = tiles.filter { $0.suitCategory == .character }.count
        let dotCount = tiles.filter { $0.suitCategory == .dot }.count
        let suitCounts = [bambooCount, characterCount, dotCount].filter { $0 > 0 }
        
        print("   Bamboo: \(bambooCount), Character: \(characterCount), Dot: \(dotCount)")
        
        // Strategy 1: If we have multiple suits, narrow down by suit first
        if suitCounts.count > 1 {
            // Ask about the most common suit
            if bambooCount > 0 && bambooCount >= characterCount && bambooCount >= dotCount {
                return OracleQuestion(
                    questionText: "Is it Bamboo?",
                    predicate: { $0.suitCategory == .bamboo }
                )
            }
            
            if characterCount > 0 && characterCount >= dotCount {
                return OracleQuestion(
                    questionText: "Is it Character?",
                    predicate: { $0.suitCategory == .character }
                )
            }
            
            if dotCount > 0 {
                return OracleQuestion(
                    questionText: "Is it Dot?",
                    predicate: { $0.suitCategory == .dot }
                )
            }
        }
        
        // Strategy 2: Same suit, narrow by number
        // Use binary search on numbers
        let numbers = tiles.map { $0.numericalValue }.sorted()
        let uniqueNumbers = Set(numbers)
        
        print("   Unique numbers: \(uniqueNumbers.sorted())")
        
        if uniqueNumbers.count > 1 {
            // Find best split point
            let median = numbers[numbers.count / 2]
            let lowerCount = tiles.filter { $0.numericalValue < median }.count
            let upperCount = tiles.filter { $0.numericalValue >= median }.count
            
            // Use median as split point
            if lowerCount > 0 && upperCount > 0 {
                return OracleQuestion(
                    questionText: "Is the number \(median) or higher?",
                    predicate: { $0.numericalValue >= median }
                )
            }
            
            // Try different splits
            for splitPoint in [5, 3, 7, 4, 6] {
                let lower = tiles.filter { $0.numericalValue < splitPoint }.count
                let upper = tiles.filter { $0.numericalValue >= splitPoint }.count
                
                if lower > 0 && upper > 0 {
                    return OracleQuestion(
                        questionText: "Is the number \(splitPoint) or higher?",
                        predicate: { $0.numericalValue >= splitPoint }
                    )
                }
            }
            
            // Ask about specific number if only 2-3 options left
            if uniqueNumbers.count <= 3 {
                let sortedNumbers = uniqueNumbers.sorted()
                let targetNumber = sortedNumbers[sortedNumbers.count / 2]
                return OracleQuestion(
                    questionText: "Is it number \(targetNumber)?",
                    predicate: { $0.numericalValue == targetNumber }
                )
            }
        }
        
        // Fallback: shouldn't reach here
        print("⚠️ Fallback question generation")
        return nil
    }
}

