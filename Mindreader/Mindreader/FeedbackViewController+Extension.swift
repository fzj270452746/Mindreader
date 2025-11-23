//
//  FeedbackViewController+Extension.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

// MARK: - UITextView Delegate
extension FeedbackViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        // Update character count
        let count = textView.text.count
        characterCountLabel.text = "\(count)/300"
        
        // Change color when approaching limit
        if count > 280 {
            characterCountLabel.textColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        } else {
            characterCountLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 300
    }
}

// MARK: - Feedback Model
struct FeedbackModel: Codable {
    let uniqueIdentifier: String
    let rating: Int
    let feedbackText: String
    let timestampDate: Date
}

