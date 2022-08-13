//
//  CategoryCollectionTableViewCell.swift
//  Fridgify
//
//  Created by Murad Bayramli on 13.08.22.
//

import UIKit

class CategoryCollectionTableViewCell: UITableViewCell {
    
    static let identifier = "CategoryCollectionTableViewCell"
    var models = [RecipeCategoryModel]()
    
    @IBOutlet var categoryCollectionView: UICollectionView!
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryCollectionTableViewCell", bundle: nil)
    }
    
    func configure(with models: [RecipeCategoryModel]) {
        self.models = models
        categoryCollectionView.reloadData()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryCollectionView.register(CircleRecipeCollectionViewCell.nib(), forCellWithReuseIdentifier: CircleRecipeCollectionViewCell.identifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
    }
    
    
    
}

//MARK: - CollectionView
extension CategoryCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleRecipeCollectionViewCell.identifier, for: indexPath) as! CircleRecipeCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
}
