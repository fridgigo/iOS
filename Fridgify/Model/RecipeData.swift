//
//  Recipe.swift
//  Fridgify
//
//  Created by Murad Bayramli on 27.07.22.
//


import Foundation
import Alamofire

// MARK: - RecipeWelcome
struct RecipeDataMain: Codable {
    let status: Bool
    let data: RecipeData
    
    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

// MARK: - RecipeData
struct RecipeData: Codable {
    let _id, title, category: String
    let preparationTime, cookingTime, servings: Int
    let ingredients: [Ingredient]
    let nutritionFacts: NutritionFacts
    let steps: [Step]


    enum CodingKeys: String, CodingKey {
        case _id, title, category
        case preparationTime = "preparation_time"
        case cookingTime = "cooking_time"
        case servings, ingredients
        case nutritionFacts = "nutrition_facts"
        case steps
    }
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let title: [String]
    let count: Int
    let increment: Double
    let measure: Measure
    let description: String

    enum CodingKeys: String, CodingKey {
        case title, count, increment, measure, description
    }
    
}

// MARK: - Measure
struct Measure: Codable {
    let title: String

    enum CodingKeys: String, CodingKey {
        case title
    }
}

// MARK: - NutritionFacts
struct NutritionFacts: Codable {
    let cal, carbs: Int
    let protein, fat: Double
    

    enum CodingKeys: String, CodingKey {
        case cal, carbs, protein, fat
    }
}

// MARK: - Step
struct Step: Codable {
    let text: String

    enum CodingKeys: String, CodingKey {
        case text
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
