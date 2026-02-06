//
//  QuestionData.swift
//  PersonalityQuiz
//
//  Created by Abdullah on 05/02/2026.
//

import Foundation


struct Question {
    var text : String
    var type : ResponseType
    var answers: [Answer]
}

enum ResponseType {
    case single, multiple, ranged
}

struct Answer {
    var text: String
    var type: AnimalType
}

enum AnimalType: Character {
    case lion = "🦁", cat = "🐱", rabbit = "🐰", turtle = "🐢"
    
    var definition : String {
        switch self {
        case .lion: return "You are incredibly outgoing. You surround yourself with the people you love and enjoy activities with your friends."
        case .cat: return "Michivieous,  yet mild-tempeted, you enjoy doing things on your own terms."
        case .rabbit: return "You love everything that's soft. You are healthy and full of energy."
        case .turtle: return "You are wise beyond your years, and you focus on the details. Slow and steady wins the race."
        }
    }
}
