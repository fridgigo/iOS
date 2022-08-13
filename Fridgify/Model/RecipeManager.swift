//
//  RecipeManager.swift
//  Fridgify
//
//  Created by Murad Bayramli on 31.07.22.
//

import Foundation
import UIKit
import Alamofire
import SCLAlertView

protocol RecipeManagerDelegate {
    func didReceiveRecipe(recipeTitleWithID: RecipeTitleModel)
    func didReceiveRecipeData(recipeData: RecipeData)
}

struct RecipeManager {
    
    var delegate: RecipeManagerDelegate?
    
    func fetchRecipe(id: String){
        let recipeURL = K.apiBaseURL + K.getRecipe + id
        requestRecipeData(url: recipeURL)
    }
    
    func fetchRecipeTitleWithID() {
        let recipeURL = K.apiBaseURL + K.getRecipes
        requestRecipes(url: recipeURL)
    }
    
    func requestRecipes(url: String) {
        let params: [String:String] = ["token":UserDefaults.standard.string(forKey: "token")!]
        
        AF.request(url, method: .get, parameters: params).responseData { response in
            
            switch response.result {
            case .success(_):
                
                let json = try! JSONSerialization.jsonObject(with: response.data!, options: .topLevelDictionaryAssumed)
                if let jsonTopLevel = json as? [String:Any] {
                    let res = jsonTopLevel["status"] as! Bool
                    if res {
                        if let data = response.data {
                            if let recipe = self.parseJSON(recipesData: data) {
                                self.delegate?.didReceiveRecipe(recipeTitleWithID: recipe)
                            }
                        }
                    } else {
                        SCLAlertView().showError(NSLocalizedString("Error", comment: ""), subTitle: jsonTopLevel["message"] as! String)
                    }
                }
                
            case .failure(let error):
                SCLAlertView().showError(NSLocalizedString("Error", comment: ""), subTitle: error.localizedDescription)
                
            }
            
            
        }
        
    }
    
    func requestRecipeData(url: String) {
        let params: [String:String] = ["token":UserDefaults.standard.string(forKey: "token")!]
        
        AF.request(url, method: .get, parameters: params).responseData { response in
            
            switch response.result {
            case .success(_):
                
                let json = try! JSONSerialization.jsonObject(with: response.data!, options: .topLevelDictionaryAssumed)
                if let jsonTopLevel = json as? [String:Any] {
                    let res = jsonTopLevel["status"] as! Bool
                    if res {
                        if let data = response.data {
                            print(String(data: data, encoding: .utf8)!)
                            if let recipe = self.parseJSON_recipeData(recipeData: data) {
                                self.delegate?.didReceiveRecipeData(recipeData: recipe)
                            }
                        }
                    } else {
                        SCLAlertView().showError(NSLocalizedString("Error", comment: ""), subTitle: jsonTopLevel["message"] as! String)
                    }
                }
                
            case .failure(let error):
                SCLAlertView().showError(NSLocalizedString("Error", comment: ""), subTitle: error.localizedDescription)
                
            }
            
            
        }
    }
    
    func parseJSON_recipeData(recipeData: Data) -> RecipeData? {
        let decoder = JSONDecoder()
        do {
            let decodedRecipesData = try decoder.decode(RecipeDataMain.self, from: recipeData)
            print("decoded recipes data: \(decodedRecipesData)")
            let id = decodedRecipesData.data._id
            let title = decodedRecipesData.data.title
            let category = decodedRecipesData.data.category
            let p = decodedRecipesData.data.preparationTime
            let c = decodedRecipesData.data.cookingTime
            let servings = decodedRecipesData.data.servings
            let i = decodedRecipesData.data.ingredients
            let n = decodedRecipesData.data.nutritionFacts
            let s = decodedRecipesData.data.steps
            
            let recipe = RecipeData(_id: id, title: title, category: category, preparationTime: p, cookingTime: c, servings: servings, ingredients: i, nutritionFacts: n, steps: s)
            
            return recipe
        } catch {
            print(error)
            return nil
        }
    }
    
    func parseJSON(recipesData: Data) -> RecipeTitleModel? {
        let decoder = JSONDecoder()
        do {
            let decodedRecipesData = try decoder.decode(RecipeTitles.self, from: recipesData)
            print("decoded recipes data: \(decodedRecipesData)")
            
            let id = decodedRecipesData.data[0]._id
            let title = decodedRecipesData.data[0].title
            
            let recipe = RecipeTitleModel(_id: id, title: title)
            return recipe
            
        } catch {
            print(error)
            return nil
        }
    }
    
}
