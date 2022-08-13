//
//  RecipeViewController.swift
//  Fridgify
//
//  Created by Murad Bayramli on 31.07.22.
//

import UIKit

struct TextCellViewModel {
    let text: String
    let font: UIFont
}

enum SectionType {
    case recipePhotos(images: [UIImage])
    case recipeIngredients(viewModels: [TextCellViewModel])
    case recipeDescription
}

class RecipeViewController: UIViewController {

    
    var recipeManager = RecipeManager()
    var recipeID: String?
    var recipeTitle: String?
    
    var recipe: RecipeData?
    
    private let recipeTable: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: K.cell)
        table.register(RecipePhotoCarouselTableViewCell.self, forCellReuseIdentifier: RecipePhotoCarouselTableViewCell.identifier)
        return table
    }()
    
    private var sections = [SectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        configureSections()
        view.addSubview(recipeTable)
        NotificationCenter.default.addObserver(self, selector: #selector(getRecipeData), name: NSNotification.Name(rawValue: K.notify_GetRecipeData), object: nil)
        
        recipeManager.delegate = self
        recipeManager.fetchRecipeTitleWithID()
        
        recipeTable.dataSource = self
        recipeTable.delegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recipeTable.frame = view.bounds
    }
    
    private func updateSections(){
        var ingredients: [String] = []
        for i in recipe!.ingredients {
            
            if i.title.count > 1 {
                var str: [String] = []
                for j in i.title {
                    str.append(j)
                }
                let s = str.joined(separator: " or ")
                ingredients.append(s)
                
            } else {
                ingredients.append(i.title[0])
            }
        }
        
        for i in ingredients {
            print(i)
            sections.append(.recipeIngredients(viewModels: [TextCellViewModel(text: "✔️ \(i)", font: UIFont(name: "Croogla4F", size: 28.0)!)]))
        }
        
        recipeTable.reloadData()
    }
    
    private func configureSections(){
        
        
        
        sections.append(.recipePhotos(images: [
            
            UIImage(named: "eggs1"),
            UIImage(named: "eggs2"),
            UIImage(named: "eggs3"),
            UIImage(named: "eggs4")
        
        ].compactMap({ $0 })))
        sections.append(.recipeIngredients(viewModels: [TextCellViewModel(text: "Ingredients: \n", font: UIFont(name: "Croogla4F", size: 40.0)!)]))
        //sections.append(.recipeDescription)
    }
    
    @objc func getRecipeData() {
        
        if let id = recipeID {
            recipeManager.fetchRecipe(id: id)
        }
        
        
    }
    
    func showRecipe(recipe: RecipeData) {
        
    }


}


//MARK: - RecipeManagerDelegate

extension RecipeViewController: RecipeManagerDelegate {
    
    func didReceiveRecipe(recipeTitleWithID: RecipeTitleModel) {
        print(recipeTitleWithID._id)
        print(recipeTitleWithID.title)
        
        recipeID = recipeTitleWithID._id
        recipeTitle = recipeTitleWithID.title
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: K.notify_GetRecipeData), object: nil)
        title = recipeTitle
    }
    
    func didReceiveRecipeData(recipeData: RecipeData) {
        print(recipeData)
        recipe = recipeData
        updateSections()
    }
    
}

//MARK: - RecipeTableViewDataSource

extension RecipeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = sections[indexPath.section]
        
        switch sectionType{
        case .recipePhotos(let images):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipePhotoCarouselTableViewCell.identifier, for: indexPath) as? RecipePhotoCarouselTableViewCell else {
                fatalError()
            }
            cell.configure(with: images)
            return cell
        case .recipeIngredients(let viewModels):
            let viewModel = viewModels[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: K.cell, for: indexPath)
            cell.configure(with: viewModel)
            return cell
                
        case .recipeDescription:
            break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell, for: indexPath)
        cell.textLabel?.text = "Hello World"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .recipePhotos:
            return view.frame.size.width
        case .recipeIngredients:
            return UITableView.automaticDimension
        case .recipeDescription:
            return UITableView.automaticDimension
        }
    }
}

//MARK: - RecipeTableViewDelegate
extension RecipeViewController: UITableViewDelegate {
    
}

extension UITableViewCell {
    func configure(with viewModel: TextCellViewModel) {
        textLabel?.text = viewModel.text
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = .byWordWrapping
        textLabel?.font = viewModel.font
    }
}


