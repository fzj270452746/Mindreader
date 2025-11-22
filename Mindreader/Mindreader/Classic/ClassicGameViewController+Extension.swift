//
//  ClassicGameViewController+Extension.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

// MARK: - UICollectionView Delegate & DataSource
extension ClassicGameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableTilesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileCell", for: indexPath) as! TileCollectionViewCell
        let tile = availableTilesArray[indexPath.item]
        cell.configureCellWithTile(tile)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTile = availableTilesArray[indexPath.item]
        evaluateGuess(selectedTile)
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.animateSpringBounce()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 12 * 2
        let width = (collectionView.bounds.width - totalSpacing) / 3
        return CGSize(width: width, height: width * 1.3)
    }
}

// MARK: - Tile Collection View Cell
class TileCollectionViewCell: UICollectionViewCell {
    
    let tileImageView = UIImageView()
    let tileNumberLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        backgroundColor = UIColor.white.withAlphaComponent(0.95)
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray5.cgColor
        applyElegantShadow(opacity: 0.2, radius: 4)
        
        tileImageView.contentMode = .scaleAspectFit
        tileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tileImageView)
        
        tileNumberLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        tileNumberLabel.textColor = .darkGray
        tileNumberLabel.textAlignment = .center
        tileNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tileNumberLabel)
        
        NSLayoutConstraint.activate([
            tileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            tileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            tileImageView.bottomAnchor.constraint(equalTo: tileNumberLabel.topAnchor, constant: -4),
            
            tileNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            tileNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            tileNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            tileNumberLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configureCellWithTile(_ tile: MahjongTileModel) {
        tileImageView.image = tile.tileImage
        tileNumberLabel.text = "\(tile.numericalValue)"
    }
}

