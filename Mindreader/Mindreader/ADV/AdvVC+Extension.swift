//
//  AdvancedGameViewController+Extension.swift
//  Mindreader
//
//  Created by Zhao on 2025/11/17.
//

import UIKit

// MARK: - UICollectionView Delegate & DataSource
extension AdvVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allAvailableTiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvancedTileCell", for: indexPath) as! AdvancedTileCell
        let tile = allAvailableTiles[indexPath.item]
        cell.configureCellWithTile(tile)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTile = allAvailableTiles[indexPath.item]
        evaluateGuess(selectedTile)
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.animateSpringBounce()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 10 * 2
        let width = (collectionView.bounds.width - totalSpacing) / 3
        return CGSize(width: width, height: width * 1.25)
    }
}

// MARK: - Advanced Tile Collection View Cell
class AdvancedTileCell: UICollectionViewCell {
    
    let tileImageView = UIImageView()
    let tileLabelView = UIView()
    let tileNumberLabel = UILabel()
    let tileSuitLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        backgroundColor = UIColor.white.withAlphaComponent(0.95)
        layer.cornerRadius = 10
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.systemGray4.cgColor
        applyElegantShadow(opacity: 0.2, radius: 4)
        
        tileImageView.contentMode = .scaleAspectFit
        tileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tileImageView)
        
        tileLabelView.backgroundColor = UIColor.systemGray6
        tileLabelView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tileLabelView)
        
        tileNumberLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        tileNumberLabel.textColor = .darkGray
        tileNumberLabel.textAlignment = .center
        tileNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        tileLabelView.addSubview(tileNumberLabel)
        
        tileSuitLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        tileSuitLabel.textColor = .systemGray
        tileSuitLabel.textAlignment = .center
        tileSuitLabel.translatesAutoresizingMaskIntoConstraints = false
        tileLabelView.addSubview(tileSuitLabel)
        
        NSLayoutConstraint.activate([
            tileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            tileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            tileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            tileImageView.bottomAnchor.constraint(equalTo: tileLabelView.topAnchor, constant: -2),
            
            tileLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tileLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tileLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tileLabelView.heightAnchor.constraint(equalToConstant: 36),
            
            tileNumberLabel.topAnchor.constraint(equalTo: tileLabelView.topAnchor, constant: 4),
            tileNumberLabel.centerXAnchor.constraint(equalTo: tileLabelView.centerXAnchor),
            
            tileSuitLabel.topAnchor.constraint(equalTo: tileNumberLabel.bottomAnchor, constant: 2),
            tileSuitLabel.centerXAnchor.constraint(equalTo: tileLabelView.centerXAnchor),
            tileSuitLabel.bottomAnchor.constraint(equalTo: tileLabelView.bottomAnchor, constant: -4)
        ])
    }
    
    func configureCellWithTile(_ tile: MahjongTileModel) {
        tileImageView.image = tile.tileImage
        tileNumberLabel.text = "\(tile.numericalValue)"
        tileSuitLabel.text = String(tile.suitCategory.rawValue.prefix(3)).uppercased()
    }
}

